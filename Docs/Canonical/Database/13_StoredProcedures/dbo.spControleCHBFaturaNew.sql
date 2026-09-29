SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE Procedure [dbo].[spControleCHBFaturaNew]

AS

--Versao de Teste Anderson

select 
		Nome_RAz_Soc Nome_Grupo,hou.num_proc_hia processo,
		Nome_Local Destino,etd_lia ETD,atd_lia ATD,
	eta_lia ETA, ATA_LIA ATA,TP.dt_conclusao DDP,
	DOCF.dt_conclusao DOC_F,max(emissao) Emissao_NF,
	max(convert(datetime,CXA.Dt_Pgto_Rcto_hia,105)) Receipt_Date,
	Max(Data_PC) DATA_PRESTACAO,sum(adto.vlr_pgto_rcto_hia) Vlr_Adiantamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hia,26) Envio_Docs_Faturamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hia,35) Recebimento_Faturamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hia,40) Envio_Prestacao

from house_imp_aer HOU
		Join Pessoa_llp PP on PP.cd_pes=cd_consig_hia
		Join Pessoa GRUPO on GRUPO.cd_pes=cd_pes_Grupo
		Join Localidade DST on DST.cd_local=cd_dst_hia
		Join LLP_Imp_Aer on hou.num_proc_hia=num_proc_lia
		Left Join Tarefas_Processos TP on TP.num_proc=num_proc_lia and TP.id_task=4
		Left Join Tarefas_Processos DOCF on DOCF.num_proc=num_proc_lia and DOCF.id_task=26
		LEft Join Cta_Cte_hou_imp_aer CTA on CTA.num_proc_hia=num_proc_lia and cd_cred_Dev_hia=cd_consig_hia and num_nf_hia is not null and ref_acesso_nf_hia <> 'P'
		Left Join BAse_Nota_Fiscal BF on BF.nota_fiscal=Num_nf_hia and BF.ref_Acesso=ref_acesso_nf_hia
		Left Join Caixa_hou_imp_Aer CXA on CTA.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_hia=cxa.dc_hia
		Left Join Fatura_CHB  FAT on FAT.processo_Pc=hou.num_proc_hia 
		Left Join Caixa_Hou_Imp_Aer ADTO on ADTO.num_proc_hia=num_proc_lia and aDTO.dc_hia='C' and ADTO.cd_Tp_tx in (Select cd_tp_tx from Tipo_Taxa where nome_tp_tx like 'Adian%')
group by

		Nome_RAz_Soc ,hou.num_proc_hia ,
		Nome_Local,etd_lia ,atd_lia ,
	eta_lia , ATA_LIA ,TP.dt_conclusao ,
	DOCF.dt_conclusao



union


select 
		Nome_RAz_Soc Nome_Grupo,hou.num_proc_him processo,
		Nome_Local Destino,etd_lim ETD,atd_lim ATD,
	eta_lim ETA, ATA_lim ATA,TP.dt_conclusao DDP,
	DOCF.dt_conclusao DOC_F,max(emissao) Emissao_NF,
	max(convert(datetime,CXA.Dt_Pgto_Rcto_him,105)) Receipt_Date,
	Max(Data_PC) DATA_PRESTACAO,sum(adto.vlr_pgto_rcto_him) Vlr_Adiantamento,
	dbo.[fBusca_Tarefa](hou.num_proc_him,26) Envio_Docs_Faturamento,
	dbo.[fBusca_Tarefa](hou.num_proc_him,35) Recebimento_Faturamento,
	dbo.[fBusca_Tarefa](hou.num_proc_him,40) Envio_Prestacao


from house_imp_mar HOU
Join Pessoa_llp PP on PP.cd_pes=cd_consig_him
Join Pessoa GRUPO on GRUPO.cd_pes=cd_pes_Grupo
Join Localidade DST on DST.cd_local=cd_dst_him
Join LLP_Imp_mar on hou.num_proc_him=num_proc_lim
Left Join Tarefas_Processos TP on TP.num_proc=num_proc_lim and TP.id_task=4
Left Join Tarefas_Processos DOCF on DOCF.num_proc=num_proc_lim and DOCF.id_task=26
LEft Join Cta_Cte_hou_imp_mar CTA on CTA.num_proc_him=num_proc_lim and cd_cred_Dev_him=cd_consig_him and num_nf_him is not null and ref_acesso_nf_him <> 'P'
Left Join BAse_Nota_Fiscal BF on BF.nota_fiscal=Num_nf_him and BF.ref_Acesso=ref_acesso_nf_him
Left Join Caixa_hou_imp_mar CXA on CTA.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_him=cxa.dc_him 
Left Join Fatura_CHB  FAT on FAT.processo_Pc=hou.num_proc_him 
Left Join Caixa_Hou_Imp_mar ADTO on ADTO.num_proc_him=num_proc_lim and aDTO.dc_him='C' and ADTO.cd_Tp_tx in (Select cd_tp_tx from Tipo_Taxa where nome_tp_tx like 'Adian%')
group by

		Nome_RAz_Soc ,hou.num_proc_him ,
		Nome_Local,etd_lim ,atd_lim ,
	eta_lim , ATA_lim ,TP.dt_conclusao ,
	DOCF.dt_conclusao

UNION

select 
		Nome_RAz_Soc Nome_Grupo,hou.num_proc_hio processo,
		Nome_Local Destino,etd_LIO ETD,atd_LIO ATD,
	eta_LIO ETA, ATA_LIO ATA,TP.dt_conclusao DDP,
	DOCF.dt_conclusao DOC_F,max(emissao) Emissao_NF,
	max(convert(datetime,CXA.Dt_Pgto_Rcto_hio,105)) Receipt_Date,
	Max(Data_PC) DATA_PRESTACAO,sum(adto.vlr_pgto_rcto_hio) Vlr_Adiantamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hio,26) Envio_Docs_Faturamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hio,35) Recebimento_Faturamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hio,40) Envio_Prestacao


from house_imp_out HOU
Join Pessoa_llp PP on PP.cd_pes=cd_consig_hio
Join Pessoa GRUPO on GRUPO.cd_pes=cd_pes_Grupo
Join Localidade DST on DST.cd_local=cd_dst_hio
Join LLP_Imp_out on hou.num_proc_hio=num_proc_LIO
Left Join Tarefas_Processos TP on TP.num_proc=num_proc_LIO and TP.id_task=4
Left Join Tarefas_Processos DOCF on DOCF.num_proc=num_proc_LIO and DOCF.id_task=26
LEft Join Cta_Cte_hou_imp_out CTA on CTA.num_proc_hio=num_proc_LIO and cd_cred_Dev_hio=cd_consig_hio and num_nf_hio is not null
Left Join BAse_Nota_Fiscal BF on BF.nota_fiscal=Num_nf_hio and BF.ref_Acesso=ref_acesso_nf_hio
Left Join Caixa_hou_imp_out CXA on CTA.num_proc_hio=cxa.num_proc_hio and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_hio=cxa.dc_hio
Left Join Fatura_CHB  FAT on FAT.processo_Pc=hou.num_proc_hio 
Left Join Caixa_Hou_Imp_out ADTO on ADTO.num_proc_hio=num_proc_LIO and aDTO.dc_hio='C' and ADTO.cd_Tp_tx in (Select cd_tp_tx from Tipo_Taxa where nome_tp_tx like 'Adian%')
group by

		Nome_RAz_Soc ,hou.num_proc_hio ,
		Nome_Local,etd_LIO ,atd_LIO ,
	eta_LIO , ATA_LIO ,TP.dt_conclusao ,
	DOCF.dt_conclusao

UNION

select 
		Nome_RAz_Soc Nome_Grupo,hou.num_proc_HEA processo,
		Nome_Local Destino,etd_LEA ETD,atd_LEA ATD,
	eta_LEA ETA, ATA_LEA ATA,TP.dt_conclusao DDP,
	DOCF.dt_conclusao DOC_F,max(emissao) Emissao_NF,
	max(convert(datetime,CXA.Dt_Pgto_Rcto_HEA,105)) Receipt_Date,
	Max(Data_PC) DATA_PRESTACAO,sum(adto.vlr_pgto_rcto_HEA) Vlr_Adiantamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hea,26) Envio_Docs_Faturamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hea,35) Recebimento_Faturamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hea,40) Envio_Prestacao

from house_EXP_aer HOU
Join Pessoa_llp PP on PP.cd_pes=cd_export_hea
Join Pessoa GRUPO on GRUPO.cd_pes=cd_pes_Grupo
Join Localidade DST on DST.cd_local=cd_ORG_HEA
Join LLP_EXP_Aer on hou.num_proc_HEA=num_proc_LEA
Left Join Tarefas_Processos TP on TP.num_proc=num_proc_LEA and TP.id_task=4
Left Join Tarefas_Processos DOCF on DOCF.num_proc=num_proc_LEA and DOCF.id_task=26
LEft Join Cta_Cte_hou_EXP_aer CTA on CTA.num_proc_HEA=num_proc_LEA and cd_cred_Dev_HEA=cd_export_hea and num_nf_HEA is not null
Left Join BAse_Nota_Fiscal BF on BF.nota_fiscal=Num_nf_HEA and BF.ref_Acesso=ref_acesso_nf_HEA
Left Join Caixa_hou_EXP_Aer CXA on CTA.num_proc_HEA=cxa.num_proc_HEA and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_HEA=cxa.dc_HEA
Left Join Fatura_CHB  FAT on FAT.processo_Pc=hou.num_proc_HEA 
Left Join Caixa_Hou_EXP_Aer ADTO on ADTO.num_proc_HEA=num_proc_LEA and aDTO.dc_HEA='C' and ADTO.cd_Tp_tx in (Select cd_tp_tx from Tipo_Taxa where nome_tp_tx like 'Adian%')

group by

		Nome_RAz_Soc ,hou.num_proc_HEA ,
		Nome_Local,etd_LEA ,atd_LEA ,
	eta_LEA , ATA_LEA ,TP.dt_conclusao ,
	DOCF.dt_conclusao

union


select 
		Nome_RAz_Soc Nome_Grupo,hou.num_proc_HEM processo,
		Nome_Local Destino,etd_LEM ETD,atd_LEM ATD,
	eta_LEM ETA, ATA_LEM ATA,TP.dt_conclusao DDP,
	DOCF.dt_conclusao DOC_F,max(emissao) Emissao_NF,
	max(convert(datetime,CXA.Dt_Pgto_Rcto_HEM,105)) Receipt_Date,
	Max(Data_PC) DATA_PRESTACAO,sum(adto.vlr_pgto_rcto_HEM) Vlr_Adiantamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hem,26) Envio_Docs_Faturamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hem,35) Recebimento_Faturamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hEM,40) Envio_Prestacao


from house_EXP_MAR HOU
Join Pessoa_llp PP on PP.cd_pes=cd_export_hem
Join Pessoa GRUPO on GRUPO.cd_pes=cd_pes_Grupo
Join Localidade DST on DST.cd_local=cd_ORG_HEM
Join LLP_EXP_MAR on hou.num_proc_HEM=num_proc_LEM
Left Join Tarefas_Processos TP on TP.num_proc=num_proc_LEM and TP.id_task=4
Left Join Tarefas_Processos DOCF on DOCF.num_proc=num_proc_LEM and DOCF.id_task=26
LEft Join Cta_Cte_hou_EXP_MAR CTA on CTA.num_proc_HEM=num_proc_LEM and cd_cred_Dev_HEM=cd_export_hem and num_nf_HEM is not null and ref_acesso_nf_hem <> 'P'
Left Join BAse_Nota_Fiscal BF on BF.nota_fiscal=Num_nf_HEM and BF.ref_Acesso=ref_acesso_nf_HEM
Left Join Caixa_hou_EXP_MAR CXA on CTA.num_proc_HEM=cxa.num_proc_HEM and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_HEM=cxa.dc_HEM
Left Join Fatura_CHB  FAT on FAT.processo_Pc=hou.num_proc_HEM 
Left Join Caixa_Hou_EXP_MAR ADTO on ADTO.num_proc_HEM=num_proc_LEM and aDTO.dc_HEM='C' and ADTO.cd_Tp_tx in (Select cd_tp_tx from Tipo_Taxa where nome_tp_tx like 'Adian%')
group by

		Nome_RAz_Soc ,hou.num_proc_HEM ,
		Nome_Local,etd_LEM ,atd_LEM ,
	eta_LEM , ATA_LEM ,TP.dt_conclusao ,
	DOCF.dt_conclusao

union

select 
		Nome_RAz_Soc Nome_Grupo,hou.num_proc_heo processo,
		Nome_Local Destino,etd_leo ETD,atd_leo ATD,
	eta_leo ETA, ATA_leo ATA,TP.dt_conclusao DDP,
	DOCF.dt_conclusao DOC_F,max(emissao) Emissao_NF,
	max(convert(datetime,CXA.Dt_Pgto_Rcto_heo,105)) Receipt_Date,
	Max(Data_PC) DATA_PRESTACAO,sum(adto.vlr_pgto_rcto_heo) Vlr_Adiantamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hEO,26) Envio_Docs_Faturamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hEO,35) Recebimento_Faturamento,
	dbo.[fBusca_Tarefa](hou.num_proc_hEO,40) Envio_Prestacao


from house_EXP_out HOU
Join Pessoa_llp PP on PP.cd_pes=cd_export_heo
Join Pessoa GRUPO on GRUPO.cd_pes=cd_pes_Grupo
Join Localidade DST on DST.cd_local=cd_ORG_heo
Join LLP_EXP_out on hou.num_proc_heo=num_proc_leo
Left Join Tarefas_Processos TP on TP.num_proc=num_proc_leo and TP.id_task=4
Left Join Tarefas_Processos DOCF on DOCF.num_proc=num_proc_leo and DOCF.id_task=26
LEft Join Cta_Cte_hou_EXP_out CTA on CTA.num_proc_heo=num_proc_leo and cd_cred_Dev_heo=cd_export_heo and num_nf_heo is not null
Left Join BAse_Nota_Fiscal BF on BF.nota_fiscal=Num_nf_heo and BF.ref_Acesso=ref_acesso_nf_heo
Left Join Caixa_hou_EXP_out CXA on CTA.num_proc_heo=cxa.num_proc_heo and cta.cd_tp_tx=cxa.cd_Tp_tx and cta.dc_heo=cxa.dc_heo
Left Join Fatura_CHB  FAT on FAT.processo_Pc=hou.num_proc_heo 
Left Join Caixa_Hou_EXP_out ADTO on ADTO.num_proc_heo=num_proc_leo and aDTO.dc_heo='C' and ADTO.cd_Tp_tx in (Select cd_tp_tx from Tipo_Taxa where nome_tp_tx like 'Adian%')
group by

		Nome_RAz_Soc ,hou.num_proc_heo ,
		Nome_Local,etd_leo ,atd_leo ,
	eta_leo , ATA_leo ,TP.dt_conclusao ,
	DOCF.dt_conclusao






GO
