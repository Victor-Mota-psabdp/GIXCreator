SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from Tipo_Taxa where cd_tp_tx in ('BRO','SRV','BR2')
--cadu 29/01/15 - Incluido IMP/Exp ,[Recebimento do Faturamento SP]e data de emissao da NF
--ticket: 100-13406

CREATE Procedure [dbo].[spATL_ProcessoaFaturar_Sel]--1
		@NF	bit
as
Select Distinct 
	'Impo'	[Impo/Expo],PPC.Nome_Raz_Soc Cliente,PP.apelido Grupo,TP.num_proc Job,
	Data [ATD/ATA], org.nome_local Origem,dst.nome_local Destino, dt_conclusao [Dt Desemb],
	--[dbo].[fBusca_TipoDocCliente]('N',tp.num_proc,1)PO,
	--[dbo].[fBusca_TipoDocCliente]('N',tp.num_proc,3) [Sales Order],
	--SF.Campo_Dados [Status Financeiro],
	--Status_Descricao, 
	--[dbo].[fBuscaSaldoCaixaSemServicos_Sel](TP.num_proc) Saldo_Processo,
	--Num_Proc_MIM [Consolidada],  
	[dbo].[fBusca_Tarefa](TP.num_proc,7) Doc_Transporte, 
	[dbo].[fBusca_Tarefa](TP.num_proc,15) Averbacao,
	--[dbo].[fBusca_Tarefa](TP.num_proc,26) Doc2Faturamento
	[dbo].[fBusca_Tarefa](TP.num_proc,26)  [Docs entregue ao faturamento],
	[dbo].[fBusca_Tarefa](TP.num_proc,35) [Recebimento do Faturamento SP],
	NF.Emissao [Data da emissão NF BDP]
From 
	Tarefas_Processos TP	with(nolock) 
	Left Join vwcta_Cte cta with(nolock) on cta.num_proc_hia=tp.num_proc and cta.cd_tp_tx in ('BRO','SRV','BR2') and dc_hia='C' and cta.desp_org_hia='N'
	Left Join vwcxas cxa	with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_Tp_tx=cxa.cd_tp_Tx
	LEft Join Base_Nota_Fiscal NF	with(nolock)  on nf.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia
	Left Join Campo_processo  CP	with(nolock) on CP.num_proc=tp.num_proc and id_campo=32
	Join Grupo     GRP		with(nolock) on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa    pp		with(nolock) on pp.cd_pes=cd_pes_grupo
	Join vwcliente C		with(nolock)on c.num_proc=tp.num_proc
	Join House_Imp_mar hou	with(nolock) on hou.num_proc_him=tp.num_proC and substring(num_proc_mim,3,3) <>'CLI'
	Join Localidade org		with(nolock) on org.cd_local=cd_org_him
	Join Localidade dst		with(nolock) on dst.cd_local=cd_dst_him
	LEft Join Campo_Processo SF with(nolock) on tp.num_proc=sf.num_proc and sf.id_campo=128
	Join LLP_Imp_Mar LLP	with(nolock) on LLP.num_proc_lim=num_proc_him
	Left Join Tipo_Status_PRocesso SP with(nolock) on LLP.id_status=SP.id_status
	Join Pessoa PPC			with(nolock) on PPC.cd_pes=c.cd_cliente
Where 
	id_task=4 and dt_conclusao >=getdate()-365 and cxa.num_lcto is null
	and isnull(CP.campo_dados,'1')='1'
	and (@NF=1  or @NF=0 and emissao is null)

Union All

Select Distinct
	'Impo'	[Impo/Expo], 
	PPC.Nome_Raz_Soc,PP.apelido,TP.num_proc,Data, org.nome_local,dst.nome_local, dt_conclusao,
	--[dbo].[fBusca_TipoDocCliente]('N',tp.num_proc,1)PO,[dbo].[fBusca_TipoDocCliente]('N',tp.num_proc,3),
	--SF.Campo_Dados [Status Financeiro],	Status_Descricao, [dbo].[fBuscaSaldoCaixaSemServicos_Sel](TP.num_proc) Saldo_Processo,	Num_Proc_MIA,
	[dbo].[fBusca_Tarefa](TP.num_proc,7) Doc_Transporte, 
	[dbo].[fBusca_Tarefa](TP.num_proc,15) Averbacao,
	[dbo].[fBusca_Tarefa](TP.num_proc,26) Doc2Faturamento,
	[dbo].[fBusca_Tarefa](TP.num_proc,35) [Recebimento do Faturamento SP],
	NF.Emissao [Data da emissão NF BDP]
From 
	Tarefas_Processos TP with(nolock) 
	Left Join vwcta_Cte cta		with(nolock) on cta.num_proc_hia=tp.num_proc and cta.cd_tp_tx in ('BRO','SRV','BR2') and dc_hia='C'
	Left Join vwcxas cxa		with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_Tp_tx=cxa.cd_tp_Tx and cta.desp_org_hia='N'
	LEft Join Base_Nota_Fiscal NF with(nolock) on nf.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia
	Left Join Campo_processo CP with(nolock) on CP.num_proc=tp.num_proc and id_campo=32
	Join Grupo GRP				with(nolock) on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa pp				with(nolock) on pp.cd_pes=cd_pes_grupo
	Join vwcliente C			with(nolock) on c.num_proc=tp.num_proc
	Join House_Imp_Aer hou		with(nolock) on hou.num_proc_hia=tp.num_proC and substring(num_proc_mia,3,3) <>'CLI'
	Join Localidade org			with(nolock) on org.cd_local=cd_org_hia
	Join Localidade dst			with(nolock) on dst.cd_local=cd_dst_hia
	LEft Join Campo_Processo SF with(nolock) on tp.num_proc=sf.num_proc and sf.id_campo=128
	Join LLP_Imp_aer LLP		with(nolock) on LLP.num_proc_lia=hou.num_proc_hia
	Left Join Tipo_Status_PRocesso SP with(nolock) on LLP.id_status=SP.id_status
	Join Pessoa PPC				with(nolock) on PPC.cd_pes=cd_cliente
Where 
	id_task=4 and dt_conclusao>=getdate()-365  and cxa.num_lcto is null
	and isnull(CP.campo_dados,'1')='1'
	and (@NF=1  or @NF=0 and emissao is null)
Union All



Select  Distinct
	'Impo'	[Impo/Expo],
	PPC.Nome_Raz_Soc,PP.apelido,TP.num_proc,Data, org.nome_local,dst.nome_local, dt_conclusao,
	--[dbo].[fBusca_TipoDocCliente]('N',tp.num_proc,1)PO,[dbo].[fBusca_TipoDocCliente]('N',tp.num_proc,3),
	--SF.Campo_Dados [Status Financeiro],Status_Descricao, [dbo].[fBuscaSaldoCaixaSemServicos_Sel](TP.num_proc) Saldo_Processo,Null,
	[dbo].[fBusca_Tarefa](TP.num_proc,7) Doc_Transporte, 
	[dbo].[fBusca_Tarefa](TP.num_proc,15) Averbacao,
	[dbo].[fBusca_Tarefa](TP.num_proc,26) Doc2Faturamento,
	[dbo].[fBusca_Tarefa](TP.num_proc,35) [Recebimento do Faturamento SP],
	NF.Emissao [Data da emissão NF BDP]
From 
	Tarefas_Processos TP with(nolock) 
	Left Join vwcta_Cte cta with(nolock) on cta.num_proc_hia=tp.num_proc and cta.cd_tp_tx in ('BRO','SRV','BR2') and dc_hia='C' and cta.desp_org_hia='N'
	Left Join vwcxas cxa with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_Tp_tx=cxa.cd_tp_Tx
	LEft Join Base_Nota_Fiscal NF with(nolock)  on nf.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia
	Left Join Campo_processo CP with(nolock) on CP.num_proc=tp.num_proc and id_campo=32
	Join Grupo GRP with(nolock) on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_pes_grupo
	Join vwcliente C with(nolock)on c.num_proc=tp.num_proc
	Join House_Imp_out hou with(nolock) on hou.num_proc_hio=tp.num_proC
	Join Localidade org with(nolock)  on org.cd_local=cd_org_hio
	Join Localidade dst with(nolock)  on dst.cd_local=cd_dst_hio
	LEft Join Campo_Processo SF with(nolock) on tp.num_proc=sf.num_proc and sf.id_campo=128
	Join LLP_Imp_out LLP with(nolock) on LLP.num_proc_lio=hou.num_proc_hio
	Left Join Tipo_Status_PRocesso SP with(nolock) on LLP.id_status=SP.id_status
	Join Pessoa PPC with(nolock) on PPC.cd_pes=cd_cliente
Where 
	id_task=4 and dt_conclusao >=getdate()-365 and cxa.num_lcto is null
	and isnull(CP.campo_dados,'1')='1'
	and (@NF=1  or @NF=0 and emissao is null)

Union all

Select Distinct
	'Expo'	[Impo/Expo],
	PPC.Nome_Raz_Soc,PP.apelido,TP.num_proc,Data, org.nome_local,dst.nome_local, dt_conclusao,
	--[dbo].[fBusca_TipoDocCliente]('N',tp.num_proc,1)PO,[dbo].[fBusca_TipoDocCliente]('N',tp.num_proc,3),
	--SF.Campo_Dados [Status Financeiro],Status_Descricao, [dbo].[fBuscaSaldoCaixaSemServicos_Sel](TP.num_proc) Saldo_Processo,	Num_Proc_mem,
	[dbo].[fBusca_Tarefa](TP.num_proc,7) Doc_Transporte, 
	[dbo].[fBusca_Tarefa](TP.num_proc,15) Averbacao,
	[dbo].[fBusca_Tarefa](TP.num_proc,26) Doc2Faturamento,
	[dbo].[fBusca_Tarefa](TP.num_proc,35) [Recebimento do Faturamento SP],
	NF.Emissao [Data da emissão NF BDP]
From 
	Tarefas_Processos TP with(nolock) 
	Left Join vwcta_Cte cta with(nolock)  on cta.num_proc_hia=tp.num_proc and cta.cd_tp_tx in ('BRO','SRV','BR2') and dc_hia='C'
	Left Join vwcxas cxa with(nolock)  on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_Tp_tx=cxa.cd_tp_Tx
	LEft Join Base_Nota_Fiscal NF with(nolock)  on nf.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia
	Left Join Campo_processo CP with(nolock) on CP.num_proc=tp.num_proc and id_campo=32
	Join Grupo GRP with(nolock)  on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_pes_grupo
	Join vwcliente C with(nolock)on c.num_proc=tp.num_proc
	Join House_exp_mar hou with(nolock) on hou.num_proc_hem=tp.num_proC and substring(num_proc_mem,3,3) <>'CLI'
	Join Localidade org with(nolock)  on org.cd_local=cd_org_hem
	Join Localidade dst with(nolock)  on dst.cd_local=cd_dst_hem
	LEft Join Campo_Processo SF with(nolock) on tp.num_proc=sf.num_proc and sf.id_campo=128
	Join LLP_exp_Mar LLP with(nolock) on LLP.num_proc_lem=num_proc_hem
	Left Join Tipo_Status_PRocesso SP with(nolock) on LLP.id_status=SP.id_status
	Join Pessoa PPC with(nolock) on PPC.cd_pes=cd_cliente
Where 
	id_task=4 and dt_conclusao >=getdate()-365 and cxa.num_lcto is null
	and isnull(CP.campo_dados,'1')='1'
	and (@NF=1  or @NF=0 and emissao is null)

Union All



Select Distinct 
	'Export'	[Impo/Expo],
	PPC.Nome_Raz_Soc,PP.apelido,TP.num_proc,Data, org.nome_local,dst.nome_local, dt_conclusao,
	--[dbo].[fBusca_TipoDocCliente]('N',tp.num_proc,1)PO,[dbo].[fBusca_TipoDocCliente]('N',tp.num_proc,3),
	--SF.Campo_Dados [Status Financeiro],Status_Descricao, [dbo].[fBuscaSaldoCaixaSemServicos_Sel](TP.num_proc) Saldo_Processo,NULL,
	[dbo].[fBusca_Tarefa](TP.num_proc,7) Doc_Transporte, 
	[dbo].[fBusca_Tarefa](TP.num_proc,15) Averbacao,
	[dbo].[fBusca_Tarefa](TP.num_proc,26) Doc2Faturamento,
	[dbo].[fBusca_Tarefa](TP.num_proc,35) [Recebimento do Faturamento SP],
	NF.Emissao [Data da emissão NF BDP]
From 
	Tarefas_Processos TP with(nolock) 
	Left Join vwcta_Cte cta with(nolock)  on cta.num_proc_hia=tp.num_proc and cta.cd_tp_tx in ('BRO','SRV','BR2') and dc_hia='C' and cta.desp_org_hia='N'
	Left Join vwcxas cxa with(nolock)  on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_Tp_tx=cxa.cd_tp_Tx
	LEft Join Base_Nota_Fiscal NF with(nolock)  on nf.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia
	Left Join Campo_processo CP with(nolock) on CP.num_proc=tp.num_proc and id_campo=32
	Join Grupo GRP with(nolock) on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_pes_grupo
	Join vwcliente C with(nolock)on c.num_proc=tp.num_proc
	Join House_exp_out hou with(nolock) on hou.num_proc_heo=tp.num_proC
	Join Localidade org with(nolock)  on org.cd_local=cd_org_heo
	Join Localidade dst with(nolock)  on dst.cd_local=cd_dst_heo
	LEft Join Campo_Processo SF with(nolock) on tp.num_proc=sf.num_proc and sf.id_campo=128
	Join LLP_exp_out LLP with(nolock) on LLP.num_proc_leo=num_proc_heo
	Left Join Tipo_Status_PRocesso SP with(nolock) on LLP.id_status=SP.id_status
	Join Pessoa PPC with(nolock) on PPC.cd_pes=cd_cliente
Where 
	id_task=4 and dt_conclusao>=getdate()-365  and cxa.num_lcto is null
	and isnull(CP.campo_dados,'1')='1'
	and (@NF=1  or @NF=0 and emissao is null)
	
	
Union All


Select Distinct
	'Expo'	[Impo/Expo],
	PPC.Nome_Raz_Soc,PP.apelido,TP.num_proc,Data, org.nome_local,dst.nome_local, dt_conclusao,
	--[dbo].[fBusca_TipoDocCliente]('N',tp.num_proc,1)PO,[dbo].[fBusca_TipoDocCliente]('N',tp.num_proc,3),
	--SF.Campo_Dados [Status Financeiro],Status_Descricao, [dbo].[fBuscaSaldoCaixaSemServicos_Sel](TP.num_proc) Saldo_Processo,	Num_proc_mea,
	[dbo].[fBusca_Tarefa](TP.num_proc,7) Doc_Transporte,
	[dbo].[fBusca_Tarefa](TP.num_proc,15) Averbacao,
	[dbo].[fBusca_Tarefa](TP.num_proc,26) Doc2Faturamento,
	[dbo].[fBusca_Tarefa](TP.num_proc,35) [Recebimento do Faturamento SP],
	NF.Emissao [Data da emissão NF BDP]
From 
	Tarefas_Processos TP with(nolock) 
	Left Join vwcta_Cte cta with(nolock) on cta.num_proc_hia=tp.num_proc and cta.cd_tp_tx in ('BRO','SRV','BR2') and dc_hia='C' and cta.desp_org_hia='N'
	Left Join vwcxas cxa with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_Tp_tx=cxa.cd_tp_Tx
	LEft Join Base_Nota_Fiscal NF with(nolock)  on nf.nota_fiscal=num_nf_hia and ref_Acesso=ref_acesso_nf_hia
	Left Join Campo_processo CP with(nolock) on CP.num_proc=tp.num_proc and id_campo=32
	Join Grupo GRP with(nolock) on GRP.grupo=substring(tp.num_proc,3,3)
	Join Pessoa pp with(nolock) on pp.cd_pes=cd_pes_grupo
	Join vwcliente C with(nolock)on c.num_proc=tp.num_proc
	Join House_exp_aer hou with(nolock) on hou.num_proc_hea=tp.num_proC and substring(num_proc_mea,3,3) <>'CLI'
	Join Localidade org with(nolock) on org.cd_local=cd_org_hea
	Join Localidade dst with(nolock) on dst.cd_local=cd_dst_hea
	LEft Join Campo_Processo SF with(nolock) on tp.num_proc=sf.num_proc and sf.id_campo=128
	Join LLP_exp_aer LLP with(nolock) on LLP.num_proc_lea=num_proc_hea
	Left Join Tipo_Status_PRocesso SP with(nolock) on LLP.id_status=SP.id_status
	Join Pessoa PPC with(nolock) on PPC.cd_pes=cd_cliente
Where 
	id_task=4 and dt_conclusao >=getdate()-365  and cxa.num_lcto is null
	and isnull(CP.campo_dados,'1')='1'
	and (@NF=1  or @NF=0 and emissao is null)

GO
