SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spFaturamentoMetrics_Rel]

as

--IMPORTAÇÃO MARITIMA
select 
	tp.num_proc,nome_local Localidade,
	dbo.fBusca_TipoDocCliente('N',TP.num_proc,1)PO_Number,
	dt_conclusao,dbo.fBusca_Tarefa(tp.num_proc,7) Doc_Transporte ,
	isnull(dbo.fBusca_TipoDocCliente('D',TP.num_proc,4),
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,5)) Data_DI,
	dbo.fBusca_Tarefa(tp.num_proc,26) Envio_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,35) Recebimento_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,75) Docs_ATL,
	dbo.fBusca_Tarefa(tp.num_proc,76) Faturamento_Criado,
	dbo.fBusca_Tarefa(tp.num_proc,78) Emissao_NF,
	dbo.fBusca_Tarefa(tp.num_proc,40) Envio_Prestacao,
	dbo.fBusca_Tarefa(tp.num_proc,13) Entrega_Planta,
	Isnull(Saldo_Final,0) Saldo,sum(CTA.vlr_org_hia) Valor_Lancado,sum(CTA.vlr_pgto_nf_hia) Valor_Faturado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,89,getdate()) Erro_Localizado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,90,getdate()) Solucao,
	MAS.NUM_PROC_MIM,PGR.Apelido, dbo.fBusca_TipoDocCliente('N',TP.num_proc,5) Num_DI_RE,
	--DBO.[fBusca_HistoricoDescr_Completo](tp.num_proc) Historico_Completo,
	HC.HSDDescricao Historico_Completo,
	dbo.fBusca_Tarefa(tp.num_proc,79) Pre_Faturamento
	
	from tarefas_processos TP With(nolock)
	Left Join Saldo_Adiantamento_temp AD	with (nolock)on TP.num_proc=AD.num_proc
	Join House_Imp_MAr HIM					with (nolock)on TP.num_proc=HIM.num_proc_him
	Join Master_imp_mar MAS					with (nolock)on MAS.num_proc_mim=him.num_proc_mim 
	Left Join Localidade Localidade			with (nolock)on Localidade.cd_local=cd_dst_him
	Left Join vwcta_Cte CTA					with (nolock)on cta.desp_org_hia='N' and cta.num_proc_hia=TP.num_proc and cta.dc_hia='C' and cta.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	--Left Join vwcta_Cte NFS on NFS.num_proc_hia=TP.num_proc and NFS.dc_hia='C' and NFS.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	Left Join vwCXAs CXA					with (nolock)on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia 
	Left Join Hist_Geral HG					with (nolock)on HG.hsgprocesso=tp.num_proc and cd_tp_ocor in (28,86)
	Join Grupo GRP							with (nolock)on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa PGR							with (nolock)on PGR.cd_pes=cd_pes_grupo
	left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=tp.num_proc

	where id_Task=4 and him.num_proc_mim='JOB' And dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not NULL
	and HG.hsgprocesso is null
	and (dbo.fBusca_CampoCliente(tp.num_proc,32)=1 or dbo.fBusca_CampoCliente(tp.num_proc,32) is null)
	and dt_conclusao > getdate()-365
/*
and tp.num_proc not in (
select num_proc_hia from vwcxas where cd_tp_tx in ('BRO','SRV') and dc_hia='C')

and (
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,26) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,4) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not null 

	)
*/
group by tp.num_proc,localidade.nome_local,dt_conclusao,saldo_final,mas.num_proc_mim,pgr.apelido,HC.HSDDescricao

having count(cxa.cd_tp_tx)<>COUNT(cta.cd_tp_tx) OR max(CTA.num_proc_hia) is null

union all

select 
	tp.num_proc,nome_local Localidade,dbo.fBusca_TipoDocCliente('N',TP.num_proc,1)PO_Number,dt_conclusao,dbo.fBusca_Tarefa(tp.num_proc,7) Doc_Transporte ,
	isnull(dbo.fBusca_TipoDocCliente('D',TP.num_proc,4),dbo.fBusca_TipoDocCliente('D',TP.num_proc,5)) Data_DI,
	dbo.fBusca_Tarefa(tp.num_proc,26) Envio_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,35) Recebimento_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,75) Docs_ATL,
	dbo.fBusca_Tarefa(tp.num_proc,76) Faturamento_Criado,
	dbo.fBusca_Tarefa(tp.num_proc,78) Emissao_NF,
	dbo.fBusca_Tarefa(tp.num_proc,40) Envio_Prestacao,
	dbo.fBusca_Tarefa(tp.num_proc,13) Entrega_Planta,
	Isnull(Saldo_Final,0) Saldo,sum(CTA.vlr_org_hia) Valor_Lancado,sum(cta.vlr_pgto_nf_hia) Valor_Faturado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,89,getdate()) Erro_Localizado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,90,getdate()) Selecao,
	MAS.NUM_PROC_MIM,PGR.apelido, dbo.fBusca_TipoDocCliente('N',TP.num_proc,5) ,
	--DBO.[fBusca_HistoricoDescr_Completo](tp.num_proc) Historico_Completo,
	HC.HSDDescricao Historico_Completo,
	dbo.fBusca_Tarefa(tp.num_proc,79) Pre_Faturamento

	from  tarefas_processos TP With(nolock)
	Left Join Saldo_Adiantamento_temp AD	with (nolock)on TP.num_proc=AD.num_proc
	Join House_Imp_MAr HIM					with (nolock)on TP.num_proc=HIM.num_proc_him
	Join Master_imp_mar MAS					with (nolock)on MAS.num_proc_mim=him.num_proc_mim --and him.num_proc_mim<>'JOB'
	Left Join Localidade Localidade			with (nolock)on Localidade.cd_local=cd_dst_him
	Left Join vwcta_Cte CTA					with (nolock)on cta.desp_org_hia='N' and cta.num_proc_hia=mas.num_proc_mim and cta.dc_hia='C' and cta.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	--Left Join vwcta_Cte NFS on NFS.num_proc_hia=mas.num_proc_mim and NFS.dc_hia='C' and NFS.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	Left Join vwCXAs CXA					with (nolock)on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia 
	Left Join Hist_Geral HG					with (nolock)on HG.hsgprocesso=tp.num_proc and cd_tp_ocor in (28,86)
	Join Grupo GRP							with (nolock)on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa PGR							with (nolock)on PGR.cd_pes=cd_pes_grupo
	left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=tp.num_proc
	where id_Task=4 and him.num_proc_mim<>'JOB'
	AND dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not NULL and HG.hsgprocesso is null
	and (dbo.fBusca_CampoCliente(tp.num_proc,32)=1 or dbo.fBusca_CampoCliente(tp.num_proc,32) is null)
	and dt_conclusao > getdate()-365

/*
and tp.num_proc not in (
select num_proc_hia from vwcxas where cd_tp_tx in ('BRO','SRV') and dc_hia='C')

and (
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,26) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,4) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not null 
	)
*/
group by tp.num_proc,localidade.nome_local,dt_conclusao,saldo_final,mas.num_proc_mim,pgr.apelido,HC.HSDDescricao

having count(cxa.cd_tp_tx)<>COUNT(cta.cd_tp_tx) OR MAX(CTA.NUM_PROC_HIA) IS NULL


UNION ALL
--IMPORTAÇÃO AÉREA
select 
	tp.num_proc,nome_local Localidade,dbo.fBusca_TipoDocCliente('N',TP.num_proc,1)PO_Number,dt_conclusao,dbo.fBusca_Tarefa(tp.num_proc,7) Doc_Transporte ,
	isnull(dbo.fBusca_TipoDocCliente('D',TP.num_proc,4),dbo.fBusca_TipoDocCliente('D',TP.num_proc,5)) Data_DI,
	dbo.fBusca_Tarefa(tp.num_proc,26) Envio_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,35) Recebimento_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,75) Docs_ATL,
	dbo.fBusca_Tarefa(tp.num_proc,76) Faturamento_Criado,
	dbo.fBusca_Tarefa(tp.num_proc,78) Emissao_NF,
	dbo.fBusca_Tarefa(tp.num_proc,40) Envio_Prestacao,
	dbo.fBusca_Tarefa(tp.num_proc,13) Entrega_Planta,
	Isnull(Saldo_Final,0) Saldo,sum(CTA.vlr_org_hia) Valor_Lancado,sum(cta.vlr_pgto_nf_hia) Valor_Faturado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,89,getdate()) Erro_Localizado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,90,getdate()) Selecao,
	MAS.NUM_PROC_MIa,PGR.apelido,dbo.fBusca_TipoDocCliente('N',TP.num_proc,5),
	--DBO.[fBusca_HistoricoDescr_Completo](tp.num_proc) Historico_Completo,
	HC.HSDDescricao Historico_Completo,
	dbo.fBusca_Tarefa(tp.num_proc,79) Pre_Faturamento

	from tarefas_processos TP With(nolock)
	Left Join Saldo_Adiantamento_temp AD	With(nolock)on TP.num_proc=AD.num_proc
	Join House_Imp_AER HIa					With(nolock)on TP.num_proc=HIA.num_proc_hiA
	Join Master_imp_aER MAS					With(nolock)on MAS.num_proc_miA=hiA.num_proc_miA 
	Left Join Localidade Localidade			With(nolock)on Localidade.cd_local=cd_dst_hiA
	Left Join vwcta_Cte CTA					With(nolock)on cta.desp_org_hia='N' and cta.num_proc_hia=TP.num_proc and cta.dc_hia='C' and cta.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	--Left Join vwcta_Cte NFS on NFS.num_proc_hia=TP.num_proc and NFS.dc_hia='C' and NFS.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	Left Join vwCXAs CXA					With(nolock)on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia 
	Left Join Hist_Geral HG					With(nolock)on HG.hsgprocesso=tp.num_proc and cd_tp_ocor in (28,86)
	Join Grupo GRP							With(nolock)on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa PGR							With(nolock)on PGR.cd_pes=cd_pes_grupo
	left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=tp.num_proc
	where id_Task=4 and hiA.num_proc_miA='JOB'
	AND dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not NULL and HG.hsgprocesso is null
	and (dbo.fBusca_CampoCliente(tp.num_proc,32)=1 or dbo.fBusca_CampoCliente(tp.num_proc,32) is null)
	and dt_conclusao > getdate()-365
/*
and tp.num_proc not in (
select num_proc_hia from vwcxas where cd_tp_tx in ('BRO','SRV') and dc_hia='C')

and (
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,26) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,4) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not null 
	)
*/
group by tp.num_proc,localidade.nome_local,dt_conclusao,saldo_final,mas.num_proc_miA,pgr.apelido,HC.HSDDescricao

having count(cxa.cd_tp_tx)<>COUNT(cta.cd_tp_tx) OR MAX(CTA.NUM_PROC_HIA) IS NULL 

union  all

select 
	tp.num_proc,nome_local Localidade,dbo.fBusca_TipoDocCliente('N',TP.num_proc,1)PO_Number,dt_conclusao,dbo.fBusca_Tarefa(tp.num_proc,7) Doc_Transporte ,
	isnull(dbo.fBusca_TipoDocCliente('D',TP.num_proc,4),dbo.fBusca_TipoDocCliente('D',TP.num_proc,5)) Data_DI,
	dbo.fBusca_Tarefa(tp.num_proc,26) Envio_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,35) Recebimento_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,75) Docs_ATL,
	dbo.fBusca_Tarefa(tp.num_proc,76) Faturamento_Criado,
	dbo.fBusca_Tarefa(tp.num_proc,78) Emissao_NF,
	dbo.fBusca_Tarefa(tp.num_proc,40) Envio_Prestacao,
	dbo.fBusca_Tarefa(tp.num_proc,13) Entrega_Planta,
	Isnull(Saldo_Final,0) Saldo,sum(CTA.vlr_org_hia) Valor_Lancado,sum(cta.vlr_pgto_nf_hia) Valor_Faturado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,89,getdate()) Erro_Localizado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,90,getdate()) Selecao,
	MAS.NUM_PROC_MIA,PGR.apelido,dbo.fBusca_TipoDocCliente('N',TP.num_proc,5),
	--DBO.[fBusca_HistoricoDescr_Completo](tp.num_proc) Historico_Completo,
	HC.HSDDescricao Historico_Completo,
	dbo.fBusca_Tarefa(tp.num_proc,79) Pre_Faturamento

	from  tarefas_processos TP With(nolock)
	Left Join Saldo_Adiantamento_temp AD	With(nolock)on TP.num_proc=AD.num_proc
	Join House_Imp_AER HIA					With(nolock)on TP.num_proc=HIA.num_proc_hia
	Join Master_imp_AER MAS					With(nolock)on MAS.num_proc_mia=hia.num_proc_mia --and him.num_proc_mim<>'JOB'
	Left Join Localidade Localidade			With(nolock)on Localidade.cd_local=cd_dst_hia
	Left Join vwcta_Cte CTA					With(nolock)on cta.desp_org_hia='N' and cta.num_proc_hia=mas.num_proc_mia and cta.dc_hia='C' and cta.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	--Left Join vwcta_Cte NFS on NFS.num_proc_hia=mas.num_proc_mia and NFS.dc_hia='C' and NFS.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	Left Join vwCXAs CXA					With(nolock)on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia 
	Left Join Hist_Geral HG					With(nolock)on HG.hsgprocesso=tp.num_proc and cd_tp_ocor in (28,86)
	Join Grupo GRP							With(nolock)on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa PGR							With(nolock)on PGR.cd_pes=cd_pes_grupo
	left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=tp.num_proc
	where id_Task=4 and hia.num_proc_mia<>'JOB'
	AND dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not NULL
	and HG.hsgprocesso is null
	and (dbo.fBusca_CampoCliente(tp.num_proc,32)=1 or dbo.fBusca_CampoCliente(tp.num_proc,32) is null)
	and dt_conclusao > getdate()-365
/*
and tp.num_proc not in (
select num_proc_hia from vwcxas where cd_tp_tx in ('BRO','SRV') and dc_hia='C')

and (
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,26) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,4) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not null 
	)
*/
group by tp.num_proc,localidade.nome_local,dt_conclusao,saldo_final,mas.num_proc_mia,pgr.apelido,HC.HSDDescricao

having count(cxa.cd_tp_tx)<>COUNT(cta.cd_tp_tx) OR MAX(CTA.NUM_PROC_HIA) IS NULL

UNION ALL

select 
	tp.num_proc,nome_local Localidade,dbo.fBusca_TipoDocCliente('N',TP.num_proc,1)PO_Number,dt_conclusao,dbo.fBusca_Tarefa(tp.num_proc,7) Doc_Transporte ,
	isnull(dbo.fBusca_TipoDocCliente('D',TP.num_proc,4),dbo.fBusca_TipoDocCliente('D',TP.num_proc,5)) Data_DI,
	dbo.fBusca_Tarefa(tp.num_proc,26) Envio_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,35) Recebimento_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,75) Docs_ATL,
	dbo.fBusca_Tarefa(tp.num_proc,76) Faturamento_Criado,
	dbo.fBusca_Tarefa(tp.num_proc,78) Emissao_NF,
	dbo.fBusca_Tarefa(tp.num_proc,40) Envio_Prestacao,
	dbo.fBusca_Tarefa(tp.num_proc,13) Entrega_Planta,
	Isnull(Saldo_Final,0) Saldo,sum(CTA.vlr_org_hia) Valor_Lancado,sum(cta.vlr_pgto_nf_hia) Valor_Faturado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,89,getdate()) Erro_Localizado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,90,getdate()) Selecao,
	'JOB',PGR.apelido,dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) ,
	--DBO.[fBusca_HistoricoDescr_Completo](tp.num_proc) Historico_Completo,
	HC.HSDDescricao Historico_Completo,
	dbo.fBusca_Tarefa(tp.num_proc,79) Pre_Faturamento

	from  tarefas_processos TP With(nolock)
	Left Join Saldo_Adiantamento_temp AD	With(nolock)on TP.num_proc=AD.num_proc
	Join House_Imp_Out HIO					With(nolock)on TP.num_proc=HIO.num_proc_hio
	Left Join Localidade Localidade			With(nolock)on Localidade.cd_local=cd_dst_hio
	Left Join vwcta_Cte CTA					With(nolock)on cta.desp_org_hia='N' and cta.num_proc_hia=TP.num_proc and cta.dc_hia='C' and cta.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	--Left Join vwcta_Cte NFS on NFS.num_proc_hia=TP.num_proc and NFS.dc_hia='C' and NFS.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	Left Join vwCXAs CXA					With(nolock)on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia 
	Left Join Hist_Geral HG					With(nolock)on HG.hsgprocesso=tp.num_proc and cd_tp_ocor in (28,86)
	Join Grupo GRP							With(nolock)on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa PGR							With(nolock)on PGR.cd_pes=cd_pes_grupo
	left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=tp.num_proc
	where id_Task=4 
	and (dbo.fBusca_CampoCliente(tp.num_proc,32)=1 or dbo.fBusca_CampoCliente(tp.num_proc,32) is null)
	AND dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not NULL and HG.hsgprocesso is null
	and dt_conclusao > getdate()-365
/*
and tp.num_proc not in (
select num_proc_hia from vwcxas where cd_tp_tx in ('BRO','SRV') and dc_hia='C')

and (
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,26) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,4) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not null 
	)
*/
group by tp.num_proc,localidade.nome_local,dt_conclusao,saldo_final,pgr.apelido,HC.HSDDescricao

having count(cxa.cd_tp_tx)<>COUNT(cta.cd_tp_tx) OR MAX(CTA.NUM_PROC_HIA) IS NULL


UNION ALL

select 
	tp.num_proc,nome_local Localidade,dbo.fBusca_TipoDocCliente('N',TP.num_proc,1)PO_Number,dt_conclusao,dbo.fBusca_Tarefa(tp.num_proc,7) Doc_Transporte ,
	isnull(dbo.fBusca_TipoDocCliente('D',TP.num_proc,4),dbo.fBusca_TipoDocCliente('D',TP.num_proc,5)) Data_DI,
	dbo.fBusca_Tarefa(tp.num_proc,26) Envio_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,35) Recebimento_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,75) Docs_ATL,
	dbo.fBusca_Tarefa(tp.num_proc,76) Faturamento_Criado,
	dbo.fBusca_Tarefa(tp.num_proc,78) Emissao_NF,
	dbo.fBusca_Tarefa(tp.num_proc,40) Envio_Prestacao,
	dbo.fBusca_Tarefa(tp.num_proc,13) Entrega_Planta,
	Isnull(Saldo_Final,0) Saldo,sum(CTA.vlr_org_hia) Valor_Lancado,sum(cta.vlr_pgto_nf_hia) Valor_Faturado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,89,getdate()) Erro_Localizado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,90,getdate()) Selecao,
	'JOB',PGR.apelido,dbo.fBusca_TipoDocCliente('D',TP.num_proc,4),
	--DBO.[fBusca_HistoricoDescr_Completo](tp.num_proc) Historico_Completo,
	HC.HSDDescricao Historico_Completo,
	dbo.fBusca_Tarefa(tp.num_proc,79) Pre_Faturamento

	from  tarefas_processos TP With(nolock)
	Left Join Saldo_Adiantamento_temp AD	With(nolock)on TP.num_proc=AD.num_proc
	Join House_exp_Out HEO					With(nolock)on TP.num_proc=HEO.num_proc_heo
	Left Join Localidade Localidade			With(nolock)on Localidade.cd_local=cd_ORG_heo
	Left Join vwcta_Cte CTA					With(nolock)on cta.desp_org_hia='N' and cta.num_proc_hia=TP.num_proc and cta.dc_hia='C' and cta.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	--Left Join vwcta_Cte NFS on NFS.num_proc_hia=TP.num_proc and NFS.dc_hia='C' and NFS.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	Left Join vwCXAs CXA					With(nolock)on   cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia 
	Left Join Hist_Geral HG					With(nolock)on HG.hsgprocesso=tp.num_proc and cd_tp_ocor in (28,86)
	Join Grupo GRP							With(nolock)on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa PGR							With(nolock)on PGR.cd_pes=cd_pes_grupo
	Join LLP_Exp_Out LLP					With(nolock)on llp.num_proc_leo=tp.num_proc
	left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=tp.num_proc
	where id_Task=4 
	and (dbo.fBusca_CampoCliente(tp.num_proc,32)=1 or dbo.fBusca_CampoCliente(tp.num_proc,32) is null)

	AND 
	(
		dbo.fBusca_TipoDocCliente('D',TP.num_proc,4) is not NULL
		OR
		dbo.fBusca_TipoDocCliente('D',TP.num_proc,26) is not NULL
	) and HG.hsgprocesso is null
	and ATD_LEO is not null
	and dt_conclusao > getdate()-365
/*
and tp.num_proc not in (
select num_proc_hia from vwcxas where cd_tp_tx in ('BRO','SRV') and dc_hia='C')

and (
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,26) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,4) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not null 
	)
*/
group by tp.num_proc,localidade.nome_local,dt_conclusao,saldo_final,pgr.apelido,HC.HSDDescricao

having count(cxa.cd_tp_tx)<>COUNT(cta.cd_tp_tx) OR MAX(CTA.NUM_PROC_HIA) IS NULL


UNION ALL

select 
	tp.num_proc,nome_local Localidade,dbo.fBusca_TipoDocCliente('N',TP.num_proc,1)PO_Number,dt_conclusao,dbo.fBusca_Tarefa(tp.num_proc,7) Doc_Transporte ,
	isnull(dbo.fBusca_TipoDocCliente('D',TP.num_proc,4),dbo.fBusca_TipoDocCliente('D',TP.num_proc,5)) Data_DI,
	dbo.fBusca_Tarefa(tp.num_proc,26) Envio_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,35) Recebimento_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,75) Docs_ATL,
	dbo.fBusca_Tarefa(tp.num_proc,76) Faturamento_Criado,
	dbo.fBusca_Tarefa(tp.num_proc,78) Emissao_NF,
	dbo.fBusca_Tarefa(tp.num_proc,40) Envio_Prestacao,
	dbo.fBusca_Tarefa(tp.num_proc,13) Entrega_Planta,
	Isnull(Saldo_Final,0) Saldo,sum(CTA.vlr_org_hia) Valor_Lancado,sum(cta.vlr_pgto_nf_hia) Valor_Faturado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,89,getdate()) Erro_Localizado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,90,getdate()) Selecao,
	'JOB', PGR.apelido,dbo.fBusca_TipoDocCliente('D',TP.num_proc,4) ,
	--DBO.[fBusca_HistoricoDescr_Completo](tp.num_proc) Historico_Completo,
	HC.HSDDescricao Historico_Completo,
	dbo.fBusca_Tarefa(tp.num_proc,79) Pre_Faturamento


	from  tarefas_processos TP With(nolock)
	Left Join Saldo_Adiantamento_temp AD	With(nolock)on TP.num_proc=AD.num_proc
	Join House_exp_AER HEA					With(nolock)on TP.num_proc=HEA.num_proc_heA
	Left Join Localidade Localidade			With(nolock)on Localidade.cd_local=cd_ORG_heA
	Left Join vwcta_Cte CTA					With(nolock)on cta.desp_org_hia='N' and cta.num_proc_hia=TP.num_proc and cta.dc_hia='C' and cta.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	--Left Join vwcta_Cte NFS on NFS.num_proc_hia=TP.num_proc and NFS.dc_hia='C' and NFS.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	Left Join vwCXAs CXA					With(nolock)on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia 
	Left Join Hist_Geral HG					With(nolock)on HG.hsgprocesso=tp.num_proc and cd_tp_ocor in (28,86)
	Join Grupo GRP							With(nolock)on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa PGR							With(nolock)on PGR.cd_pes=cd_pes_grupo
	Join LLP_Exp_Aer LLP					With(nolock)on llp.num_proc_lea=tp.num_proc
	left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=tp.num_proc
	where id_Task=4 
	and (dbo.fBusca_CampoCliente(tp.num_proc,32)=1 or dbo.fBusca_CampoCliente(tp.num_proc,32) is null)

	AND 
	(
		dbo.fBusca_TipoDocCliente('D',TP.num_proc,4) is not NULL
		OR
		dbo.fBusca_TipoDocCliente('D',TP.num_proc,26) is not NULL
	)
	and HG.hsgprocesso is null
	and ATD_LEA is not null
	and dt_conclusao > getdate()-365
/*
and tp.num_proc not in (
select num_proc_hia from vwcxas where cd_tp_tx in ('BRO','SRV') and dc_hia='C')

and (
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,26) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,4) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not null 
	)
*/
group by tp.num_proc,localidade.nome_local,dt_conclusao,saldo_final,pgr.apelido,HC.HSDDescricao

having count(cxa.cd_tp_tx)<>COUNT(cta.cd_tp_tx) OR MAX(CTA.NUM_PROC_HIA) IS NULL

UNION ALL

select 
	tp.num_proc,nome_local Localidade,dbo.fBusca_TipoDocCliente('N',TP.num_proc,1)PO_Number,dt_conclusao,dbo.fBusca_Tarefa(tp.num_proc,7) Doc_Transporte ,
	isnull(dbo.fBusca_TipoDocCliente('D',TP.num_proc,4),dbo.fBusca_TipoDocCliente('D',TP.num_proc,5)) Data_DI,
	dbo.fBusca_Tarefa(tp.num_proc,26) Envio_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,35) Recebimento_Faturamento,
	dbo.fBusca_Tarefa(tp.num_proc,75) Docs_ATL,
	dbo.fBusca_Tarefa(tp.num_proc,76) Faturamento_Criado,
	dbo.fBusca_Tarefa(tp.num_proc,78) Emissao_NF,
	dbo.fBusca_Tarefa(tp.num_proc,40) Envio_Prestacao,
	dbo.fBusca_Tarefa(tp.num_proc,13) Entrega_Planta,
	Isnull(Saldo_Final,0) Saldo,sum(CTA.vlr_org_hia) Valor_Lancado,sum(cta.vlr_pgto_nf_hia) Valor_Faturado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,89,getdate()) Erro_Localizado,
--	dbo.fBusca_HistoricoDescr(tp.num_proc,90,getdate()) Selecao,
	'JOB',PGR.apelido,dbo.fBusca_TipoDocCliente('N',TP.num_proc,4) ,
	--DBO.[fBusca_HistoricoDescr_Completo](tp.num_proc) Historico_Completo,
	HC.HSDDescricao Historico_Completo,
	dbo.fBusca_Tarefa(tp.num_proc,79) Pre_Faturamento

	from  tarefas_processos TP With(nolock)
	Left Join Saldo_Adiantamento_temp AD	With(nolock)on TP.num_proc=AD.num_proc
	Join House_exp_mar HEM					With(nolock)on TP.num_proc=HEM.num_proc_heM
	Left Join Localidade Localidade			With(nolock)on Localidade.cd_local=cd_ORG_heM
	Left Join vwcta_Cte CTA					With(nolock)on cta.desp_org_hia='N' and cta.num_proc_hia=TP.num_proc and cta.dc_hia='C' and cta.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	--Left Join vwcta_Cte NFS on NFS.num_proc_hia=TP.num_proc and NFS.dc_hia='C' and NFS.cd_tp_Tx collate Latin1_General_CI_AI  in (select * from dbo.Taxas_Despacho)
	Left Join vwCXAs CXA					With(nolock)on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia 
	Left Join Hist_Geral HG					With(nolock)on HG.hsgprocesso=tp.num_proc and cd_tp_ocor in (28,86)
	Join Grupo GRP							With(nolock)on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa PGR							With(nolock)on PGR.cd_pes=cd_pes_grupo
	Join LLP_Exp_MAR LLP					With(nolock)on llp.num_proc_lem=tp.num_proc
	left Join vwBusca_HistoricoDescr_Completo HC with(nolock)on HC.HSGProcesso=tp.num_proc
	where id_Task=4 
	and (dbo.fBusca_CampoCliente(tp.num_proc,32)=1 or dbo.fBusca_CampoCliente(tp.num_proc,32) is null)

	AND 
	(
		dbo.fBusca_TipoDocCliente('D',TP.num_proc,4) is not NULL
		OR
		dbo.fBusca_TipoDocCliente('D',TP.num_proc,26) is not NULL
	)
	and HG.hsgprocesso is null
	and ATD_Lem is not null
	and dt_conclusao > getdate()-365
/*
and tp.num_proc not in (
select num_proc_hia from vwcxas where cd_tp_tx in ('BRO','SRV') and dc_hia='C')

and (
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,26) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,4) is not null or 
	dbo.fBusca_TipoDocCliente('D',TP.num_proc,5) is not null 
	)
*/
group by tp.num_proc,localidade.nome_local,dt_conclusao,saldo_final,PGR.apelido,HC.HSDDescricao

having count(cxa.cd_tp_tx)<>COUNT(cta.cd_tp_tx)	OR MAX(CTA.NUM_PROC_HIA) IS  NULL

--option(hash join)
GO
