SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE Procedure [dbo].[spControleCHBFatura]

as

select 
	hou.num_proc_hia Processo,
	convert(datetime,dt_emis_hia,105) Emissao, 
	Ordem.numero_po_hia Order_Number,
	PO.numero_po_hia PO_Number,
	Nome_Local Destino,/*Invoice.numero_po_hia Invoice,Invoice.Data_po_hia Invoice_Date,*/
	ETD_Lia ETD,
	ATD_LIA ATD,
	PA.DT_CONCLUSAO PRE_ALERT,
	ETA_LIA ETA,
	ATA_LIA ATA,
	min(convert(datetime,CT_ADI.Dt_Ins_Hia,105)) Dt_Cta_Adi,
	min(convert(datetime,CX_ADI.Dt_Pgto_Rcto_hia,105)) Dt_CXA_Adi,
	DDP.DT_CONCLUSAO DDP,
	CANAL_LIA CANAL,
	ENT_PLAN.Dt_Conclusao Ent_Planta,
	isnull(dbo.FBusca_DtNota(hou.num_proc_hia),dbo.FBusca_DtNota(LLP.courier_Number_Lia)) EMISSAO_NF,
	--NF.EMISSAO EMISSAO_NF,
	MAX(DATA_PC) DATA_PRESTACAO,
	convert(datetime,CXA.dt_pgto_rcto_hia,105) Receipt_Date, 
	DI.Data_PO_HIA Data_DI,
	Doc_F.Dt_Conclusao Doc_F,
	convert(datetime,CX_PRE.Dt_Pgto_Rcto_hia, 105) Dt_PRE_Adi,
	DOC_CAMB.Dt_Conclusao Doc_Cambio,
	Sum (CX_ADI.vlr_pgto_rcto_hia) Valor_Adiant,
	dbo.fBusca_Tarefa(hou.num_proc_hia,35) Receb_Fatura,
	PG.Apelido										Nome_Grupo
from 
	house_imp_aer hou
	Left Join Po_Hia Ordem on HOU.Num_proc_hia=Ordem.num_proc_hia and Ordem.ID_DC=3
	Left Join Po_Hia PO on HOU.Num_proc_hia=PO.num_proc_hia and PO.ID_DC=1
	Join Localidade DST on DST.cd_local=cd_dst_hia
	--Left Join Po_Hia Invoice on HOU.Num_proc_hia=Invoice.num_proc_hia and Invoice.ID_DC=2
	Join LLp_Imp_Aer LLP on LLp.num_proc_lia=hou.num_proc_hia
	Left Join Tarefas_Processos PA on HOU.NUM_PROC_HIA=PA.NUM_PROC AND PA.ID_TASK=1
	Left Join Tarefas_Processos DDP on HOU.NUM_PROC_HIA=DDP.NUM_PROC AND DDP.ID_TASK=4
	LEFT JOIN CTA_CTE_HOU_IMP_AER CTA ON HOU.NUM_PROC_HIA=CTA.NUM_PROC_HIA AND CTA.DC_HIA='C' AND CTA.CD_TP_TX='BRO'
	LEFT JOIN CAIXA_HOU_IMP_AER CXA ON HOU.NUM_PROC_HIA=CXA.NUM_PROC_HIA AND CXA.DC_HIA='C' AND CXA.CD_TP_TX='BRO'
	LEFT JOIN CTA_CTE_HOU_IMP_AER CT_ADI ON HOU.NUM_PROC_HIA=CT_ADI.NUM_PROC_HIA AND CT_ADI.DC_HIA='C' AND CT_ADI.CD_TP_TX in ('XB2','XB3','XBA','XBC')
	LEFT JOIN CAIXA_HOU_IMP_AER  CX_ADI ON HOU.NUM_PROC_HIA=CX_ADI.NUM_PROC_HIA AND CX_ADI.DC_HIA='C' AND CX_ADI.CD_TP_TX in ('XB2','XB3','XBA','XBC')
	LEFT JOIN CAIXA_HOU_IMP_AER  CX_PRE ON HOU.NUM_PROC_HIA=CX_PRE.NUM_PROC_HIA AND CX_PRE.CD_TP_TX  in (select cd_tp_Tx from tipo_taxa where nome_tp_tx like 'Adiantamento%' and left(cd_tp_tx,1)='X')
	--LEFT JOIN BASE_NOTA_FISCAL NF ON CTA.NUM_NF_HIA=NF.NOTA_FISCAL AND CTA.REF_ACESSO_NF_HIA=NF.REF_ACESSO
	LEFT JOIN FATURA_CHB FAT ON HOU.NUM_PROC_HIA=PROCESSO_PC or HOU.NUM_PROC_MIA=PROCESSO_PC
	Left Join Tarefas_Processos DOC_F on HOU.NUM_PROC_HIA=DOC_F.NUM_PROC AND DOC_F.ID_TASK=26
	Left Join Tarefas_Processos EP on HOU.NUM_PROC_HIA=EP.NUM_PROC AND EP.ID_TASK=4
	Left Join Tarefas_Processos ENT_PLAN on HOU.NUM_PROC_HIA=ENT_PLAN.NUM_PROC AND ENT_PLAN.ID_TASK=13
	Left Join Tarefas_Processos DOC_CAMB on HOU.NUM_PROC_HIA=DOC_CAMB.NUM_PROC AND DOC_CAMB.ID_TASK=23
	Left Join Po_Hia DI on HOU.Num_proc_hia=DI.num_proc_hia and DI.ID_DC=5
	join Grupo G on G.grupo= right(left(HOU.Num_Proc_HIa,5),3)
	join pessoa PG on PG.cd_pes=G.cd_pes_grupo
	Left Join Hist_Geral CANC on CANC.HSGProcesso=HOU.Num_Proc_HIA and CANC.Cd_Tp_Ocor='28'
WHERE
	CANC.HSGProcesso is null
GROUP BY 
	hou.num_proc_hia ,convert(datetime,dt_emis_hia,105) , Ordem.numero_po_hia ,
	PO.numero_po_hia ,Nome_Local ,/*Invoice.numero_po_hia ,Invoice.Data_po_hia ,*/
	ETD_Lia ,ATD_LIA ,PA.DT_CONCLUSAO ,ETA_LIA ,ATA_LIA ,DDP.DT_CONCLUSAO,CANAL_LIA,/*NF.EMISSAO,*/
	EP.DT_CONCLUSAO, convert(datetime,CXA.dt_pgto_rcto_hia,105) , DI.Data_PO_HIA,
	Doc_F.Dt_Conclusao, ENT_PLAN.Dt_Conclusao, convert(datetime,CX_PRE.Dt_Pgto_Rcto_hia, 105), DOC_CAMB.Dt_Conclusao,
	PG.Apelido,LLP.courier_Number_Lia

union all

select 
	hou.num_proc_him Processo,
	convert(datetime,dt_emis_him,105) Emissao, 
	Ordem.numero_po_him Order_Number,
	PO.numero_po_him PO_Number,
	Nome_Local Destino,/*Invoice.numero_po_him Invoice,Invoice.Data_po_him Invoice_Date,*/
	ETD_lim ETD,
	ATD_lim ATD,
	PA.DT_CONCLUSAO PRE_ALERT,
	ETA_lim ETA,
	ATA_lim ATA,
	min(convert(datetime,CT_ADI.Dt_Ins_Him,105)) Dt_Cta_Adi,
	min(convert(datetime,CX_ADI.Dt_Pgto_Rcto_him,105)) Dt_CXA_Adi,
	DDP.DT_CONCLUSAO DDP,
	CANAL_lim CANAL,
	ENT_PLAN.Dt_Conclusao Ent_Planta,
	isnull(dbo.FBusca_DtNota(hou.num_proc_him),dbo.FBusca_DtNota(LLP.courier_Number_Lim)) EMISSAO_NF,
	--NF.EMISSAO EMISSAO_NF,
	MAX(DATA_PC) DATA_PRESTACAO,
	convert(datetime,CXA.dt_pgto_rcto_him,105) Receipt_Date, 
	DI.Data_PO_HIM Data_DI,
	Doc_F.Dt_Conclusao,
	max(convert(datetime,CX_PRE.Dt_Pgto_Rcto_him,105)) Dt_PRE_Adi,
	DOC_CAMB.Dt_Conclusao Doc_Cambio,
	Sum (CX_ADI.vlr_pgto_rcto_him) Valor_Adiant,
	dbo.fBusca_Tarefa(hou.num_proc_him,35) Receb_Fatura,
	PG.Apelido Nome_Grupo
from 
	house_imp_mar hou
	Left Join Po_him Ordem on HOU.Num_proc_him=Ordem.num_proc_him and Ordem.ID_DC=3
	Left Join Po_him PO on HOU.Num_proc_him=PO.num_proc_him and PO.ID_DC=1
	Join Localidade DST on DST.cd_local=cd_dst_him
	--Left Join Po_him Invoice on HOU.Num_proc_him=Invoice.num_proc_him and Invoice.ID_DC=2
	Join LLp_Imp_mar LLP on LLp.num_proc_lim=hou.num_proc_him
	Left Join Tarefas_Processos PA on HOU.NUM_PROC_him=PA.NUM_PROC AND PA.ID_TASK=1
	Left Join Tarefas_Processos DDP on HOU.NUM_PROC_him=DDP.NUM_PROC AND DDP.ID_TASK=4
	LEFT JOIN CTA_CTE_HOU_IMP_mar CTA ON HOU.NUM_PROC_him=CTA.NUM_PROC_him AND CTA.DC_him='C' AND CTA.CD_TP_TX='BRO'
	LEFT JOIN CAIXA_HOU_IMP_mar CXA ON HOU.NUM_PROC_him=CXA.NUM_PROC_him AND CXA.DC_him='C' AND CXA.CD_TP_TX='BRO'
	LEFT JOIN CTA_CTE_HOU_IMP_mar CT_ADI ON HOU.NUM_PROC_HIm=CT_ADI.NUM_PROC_HIm AND CT_ADI.DC_HIm='C' AND CT_ADI.CD_TP_TX in ('XB2','XB3','XBA','XBC')
	LEFT JOIN CAIXA_HOU_IMP_mar  CX_ADI ON HOU.NUM_PROC_HIm=CX_ADI.NUM_PROC_HIm AND CX_ADI.DC_HIm='C' AND CX_ADI.CD_TP_TX in ('XB2','XB3','XBA','XBC')
	LEFT JOIN CAIXA_HOU_IMP_mar  CX_PRE ON HOU.NUM_PROC_HIm=CX_PRE.NUM_PROC_HIm AND CX_PRE.CD_TP_TX in (select cd_tp_Tx from tipo_taxa where nome_tp_tx like 'Adiantamento%' and left(cd_tp_tx,1)='X')
	LEFT JOIN BASE_NOTA_FISCAL NF ON CTA.NUM_NF_him=NF.NOTA_FISCAL AND CTA.REF_ACESSO_NF_him=NF.REF_ACESSO
	LEFT JOIN FATURA_CHB FAT ON HOU.NUM_PROC_him=PROCESSO_PC or HOU.NUM_PROC_mim=PROCESSO_PC
	Left Join Tarefas_Processos EP on HOU.NUM_PROC_him=EP.NUM_PROC AND EP.ID_TASK=4
	Left Join Po_him DI on HOU.Num_proc_him=DI.num_proc_him and DI.ID_DC=5
	Left Join Tarefas_Processos ENT_PLAN on HOU.NUM_PROC_HIm=ENT_PLAN.NUM_PROC AND ENT_PLAN.ID_TASK=13
	Left Join Tarefas_Processos DOC_F on HOU.NUM_PROC_HIm=DOC_F.NUM_PROC AND DOC_F.ID_TASK=26
	Left Join Tarefas_Processos DOC_CAMB on HOU.NUM_PROC_HIM=DOC_CAMB.NUM_PROC AND DOC_CAMB.ID_TASK=23
	join Grupo G on G.grupo= right(left(HOU.Num_Proc_HIM,5),3)
	join pessoa PG on PG.cd_pes=G.cd_pes_grupo
	Left Join Hist_Geral CANC on CANC.HSGProcesso=HOU.Num_Proc_HIM and CANC.Cd_Tp_Ocor='28'
WHERE
	CANC.HSGProcesso is null
GROUP BY 
	hou.num_proc_him ,convert(datetime,dt_emis_him,105) , Ordem.numero_po_him ,
	PO.numero_po_him ,Nome_Local ,/*Invoice.numero_po_him ,Invoice.Data_po_him ,*/
	ETD_lim ,ATD_lim ,PA.DT_CONCLUSAO ,ETA_lim ,ATA_lim ,DDP.DT_CONCLUSAO,CANAL_lim,/*NF.EMISSAO,*/
	EP.DT_CONCLUSAO, convert(datetime,CXA.dt_pgto_rcto_him,105) , DI.Data_PO_HIM,
	Doc_F.Dt_Conclusao, ENT_PLAN.Dt_Conclusao, DOC_CAMB.Dt_Conclusao ,
	PG.Apelido,LLP.courier_Number_Lim

union all

select 
	hou.num_proc_hio Processo,
	convert(datetime,dt_emis_hio,105) Emissao, 
	Ordem.numero_po_hio Order_Number,
	PO.numero_po_hio PO_Number,
	Nome_Local Destino,/*Invoice.numero_po_hio Invoice,Invoice.Data_po_hio Invoice_Date,*/
	ETD_lio ETD,
	ATD_lio ATD,
	PA.DT_CONCLUSAO PRE_ALERT,
	ETA_lio ETA,
	ATA_lio ATA,
	min(convert(datetime,CT_ADI.Dt_Ins_Hio, 105)) Dt_Cta_Adi,
	min(convert(datetime,CX_ADI.Dt_Pgto_Rcto_hio, 105)) Dt_CXA_Adi,
	DDP.DT_CONCLUSAO DDP,
	CANAL_lio CANAL,
	ENT_PLAN.Dt_Conclusao Ent_Planta,
	isnull(dbo.FBusca_DtNota(hou.num_proc_hio),dbo.FBusca_DtNota(LLP.courier_Number_Lio)) EMISSAO_NF,
	--NF.EMISSAO EMISSAO_NF,
	MAX(DATA_PC) DATA_PRESTACAO,
	convert(datetime,CXA.dt_pgto_rcto_hio,105) Receipt_Date, 
	DI.Data_PO_HIO Data_DI,
	Doc_F.Dt_Conclusao Doc_F,
	convert(datetime,CX_PRE.Dt_Pgto_Rcto_hio,105) Dt_PRE_Adi,
	DOC_CAMB.Dt_Conclusao Doc_Cambio,
	Sum (CX_ADI.vlr_pgto_rcto_hio) Valor_Adiant,
	dbo.fBusca_Tarefa(hou.num_proc_hio,35) Receb_Fatura,
	PG.Apelido										Nome_Grupo
from 
	house_imp_out hou
	Left Join Po_hio Ordem on HOU.Num_proc_hio=Ordem.num_proc_hio and Ordem.ID_DC=3
	Left Join Po_hio PO on HOU.Num_proc_hio=PO.num_proc_hio and PO.ID_DC=1
	Join Localidade DST on DST.cd_local=cd_dst_hio
	--Left Join Po_hio Invoice on HOU.Num_proc_hio=Invoice.num_proc_hio and Invoice.ID_DC=2
	Join LLp_Imp_out LLP on LLp.num_proc_lio=hou.num_proc_hio
	Left Join Tarefas_Processos PA on HOU.NUM_PROC_hio=PA.NUM_PROC AND PA.ID_TASK=1
	Left Join Tarefas_Processos DDP on HOU.NUM_PROC_hio=DDP.NUM_PROC AND DDP.ID_TASK=4
	LEFT JOIN CTA_CTE_HOU_IMP_out CTA ON HOU.NUM_PROC_hio=CTA.NUM_PROC_hio AND CTA.DC_hio='C' AND CTA.CD_TP_TX='BRO'
	LEFT JOIN CAIXA_HOU_IMP_out CXA ON HOU.NUM_PROC_hio=CXA.NUM_PROC_hio AND CXA.DC_hio='C' AND CXA.CD_TP_TX='BRO'
	LEFT JOIN CTA_CTE_HOU_IMP_out CT_ADI ON HOU.NUM_PROC_HIo=CT_ADI.NUM_PROC_HIo AND CT_ADI.DC_HIo='C' AND CT_ADI.CD_TP_TX in ('XB2','XB3','XBA','XBC')
	LEFT JOIN CAIXA_HOU_IMP_out  CX_ADI ON HOU.NUM_PROC_HIo=CX_ADI.NUM_PROC_HIo AND CX_ADI.DC_HIo='C' AND CX_ADI.CD_TP_TX in ('XB2','XB3','XBA','XBC')
	LEFT JOIN CAIXA_HOU_IMP_out  CX_PRE ON HOU.NUM_PROC_HIo=CX_PRE.NUM_PROC_HIo AND CX_PRE.CD_TP_TX  in (select cd_tp_Tx from tipo_taxa where nome_tp_tx like 'Adiantamento%' and left(cd_tp_tx,1)='X')
	--LEFT JOIN BASE_NOTA_FISCAL NF ON CTA.NUM_NF_hio=NF.NOTA_FISCAL AND CTA.REF_ACESSO_NF_hio=NF.REF_ACESSO
	LEFT JOIN FATURA_CHB FAT ON HOU.NUM_PROC_hio=PROCESSO_PC 
	Left Join Tarefas_Processos EP on HOU.NUM_PROC_hio=EP.NUM_PROC AND EP.ID_TASK=4
	Left Join Po_hio DI on HOU.Num_proc_hio=DI.num_proc_hio and DI.ID_DC=5
	Left Join Tarefas_Processos ENT_PLAN on HOU.NUM_PROC_HIo=ENT_PLAN.NUM_PROC AND ENT_PLAN.ID_TASK=13
	Left Join Tarefas_Processos DOC_F on HOU.NUM_PROC_HIo=DOC_F.NUM_PROC AND DOC_F.ID_TASK=26
	Left Join Tarefas_Processos DOC_CAMB on HOU.NUM_PROC_HIO=DOC_CAMB.NUM_PROC AND DOC_CAMB.ID_TASK=23
	join Grupo G on G.grupo= right(left(HOU.Num_Proc_HIo,5),3)
	join pessoa PG on PG.cd_pes=G.cd_pes_grupo
	Left Join Hist_Geral CANC on CANC.HSGProcesso=HOU.Num_Proc_HIO and CANC.Cd_Tp_Ocor='28'
WHERE
	CANC.HSGProcesso is null
GROUP BY 
	hou.num_proc_hio ,convert(datetime,dt_emis_hio,105) , Ordem.numero_po_hio ,
	PO.numero_po_hio ,Nome_Local ,/*Invoice.numero_po_hio ,Invoice.Data_po_hio ,*/
	ETD_lio ,ATD_lio ,PA.DT_CONCLUSAO ,ETA_lio ,ATA_lio ,DDP.DT_CONCLUSAO,CANAL_lio,/*NF.EMISSAO,*/
	EP.DT_CONCLUSAO, convert(datetime,CXA.dt_pgto_rcto_hio,105) , DI.Data_PO_HIO,
	Doc_F.Dt_Conclusao, ENT_PLAN.Dt_Conclusao, convert(datetime,CX_PRE.Dt_Pgto_Rcto_hio,105), DOC_CAMB.Dt_Conclusao,
	PG.Apelido,LLP.courier_Number_Lio

union all

select 
	hou.num_proc_hea Processo,
	convert(datetime,dt_emis_hea,105) Emissao, 
	Ordem.numero_po_hea Order_Number,
	PO.numero_po_hea PO_Number,
	Nome_Local Destino,/*Invoice.numero_po_hea Invoice,Invoice.Data_po_hea Invoice_Date,*/
	ETD_lea ETD,
	ATD_lea ATD,
	PA.DT_CONCLUSAO PRE_ALERT,
	ETA_lea ETA,
	ATA_lea ATA,
	min(convert(datetime,CT_ADI.Dt_Ins_hea, 105)) Dt_Cta_Adi,
	min(convert(datetime,CX_ADI.Dt_Pgto_Rcto_hea, 105)) Dt_CXA_Adi,
	DDP.DT_CONCLUSAO DDP,
	CANAL_lea CANAL,
	ENT_PLAN.Dt_Conclusao Ent_Planta,
	isnull(dbo.FBusca_DtNota(hou.num_proc_hea),dbo.FBusca_DtNota(LLP.courier_Number_Lea)) EMISSAO_NF,
	--NF.EMISSAO EMISSAO_NF,
	MAX(DATA_PC) DATA_PRESTACAO,
	convert(datetime,CXA.dt_pgto_rcto_hea,105) Receipt_Date, 
	DI.Data_PO_hea Data_DI,
	Doc_F.Dt_Conclusao Doc_F,
	convert(datetime,CX_PRE.Dt_Pgto_Rcto_hea,105) Dt_PRE_Adi,
	DOC_CAMB.Dt_Conclusao Doc_Cambio,
	Sum (CX_ADI.vlr_pgto_rcto_hea) Valor_Adiant,
	dbo.fBusca_Tarefa(hou.num_proc_hea,35) Receb_Fatura,
	PG.Apelido										Nome_Grupo
from 
	house_exp_aer hou
	Left Join Po_hea Ordem on HOU.Num_proc_hea=Ordem.num_proc_hea and Ordem.ID_DC=3
	Left Join Po_hea PO on HOU.Num_proc_hea=PO.num_proc_hea and PO.ID_DC=1
	Join Localidade DST on DST.cd_local=cd_dst_hea
	--Left Join Po_hea Invoice on HOU.Num_proc_hea=Invoice.num_proc_hea and Invoice.ID_DC=2
	Join LLp_exp_aer LLP on LLp.num_proc_lea=hou.num_proc_hea
	Left Join Tarefas_Processos PA on HOU.NUM_PROC_hea=PA.NUM_PROC AND PA.ID_TASK=1
	Left Join Tarefas_Processos DDP on HOU.NUM_PROC_hea=DDP.NUM_PROC AND DDP.ID_TASK=4
	LEFT JOIN CTA_CTE_HOU_exp_aer CTA ON HOU.NUM_PROC_hea=CTA.NUM_PROC_hea AND CTA.DC_hea='C' AND CTA.CD_TP_TX='BRO'
	LEFT JOIN CAIXA_HOU_exp_aer CXA ON HOU.NUM_PROC_hea=CXA.NUM_PROC_hea AND CXA.DC_hea='C' AND CXA.CD_TP_TX='BRO'
	LEFT JOIN CTA_CTE_HOU_exp_aer CT_ADI ON HOU.NUM_PROC_hea=CT_ADI.NUM_PROC_hea AND CT_ADI.DC_hea='C' AND CT_ADI.CD_TP_TX in ('XB2','XB3','XBA','XBC')
	LEFT JOIN CAIXA_HOU_exp_aer  CX_ADI ON HOU.NUM_PROC_hea=CX_ADI.NUM_PROC_hea AND CX_ADI.DC_hea='C' AND CX_ADI.CD_TP_TX in ('XB2','XB3','XBA','XBC')
	LEFT JOIN CAIXA_HOU_exp_aer  CX_PRE ON HOU.NUM_PROC_hea=CX_PRE.NUM_PROC_hea AND CX_PRE.CD_TP_TX in (select cd_tp_Tx from tipo_taxa where nome_tp_tx like 'Adiantamento%' and left(cd_tp_tx,1)='X')
	--LEFT JOIN BASE_NOTA_FISCAL NF ON CTA.NUM_NF_hea=NF.NOTA_FISCAL AND CTA.REF_ACESSO_NF_hea=NF.REF_ACESSO
	LEFT JOIN FATURA_CHB FAT ON HOU.NUM_PROC_hea=PROCESSO_PC or HOU.NUM_PROC_mea=PROCESSO_PC
	Left Join Tarefas_Processos EP on HOU.NUM_PROC_hea=EP.NUM_PROC AND EP.ID_TASK=4
	Left Join Po_hea DI on HOU.Num_proc_hea=DI.num_proc_hea and DI.ID_DC=5
	Left Join Tarefas_Processos ENT_PLAN on HOU.NUM_PROC_hea=ENT_PLAN.NUM_PROC AND ENT_PLAN.ID_TASK=13
	Left Join Tarefas_Processos DOC_F on HOU.NUM_PROC_hea=DOC_F.NUM_PROC AND DOC_F.ID_TASK=26
	Left Join Tarefas_Processos DOC_CAMB on HOU.NUM_PROC_hea=DOC_CAMB.NUM_PROC AND DOC_CAMB.ID_TASK=23
	join Grupo G on G.grupo= right(left(HOU.Num_Proc_Hea,5),3)
	join pessoa PG on PG.cd_pes=G.cd_pes_grupo
	Left Join Hist_Geral CANC on CANC.HSGProcesso=HOU.Num_Proc_HEA and CANC.Cd_Tp_Ocor='28'
WHERE
	CANC.HSGProcesso is null
GROUP BY 
	hou.num_proc_hea ,convert(datetime,dt_emis_hea,105) , Ordem.numero_po_hea ,
	PO.numero_po_hea ,Nome_Local ,/*Invoice.numero_po_hea ,Invoice.Data_po_hea ,*/
	ETD_lea ,ATD_lea ,PA.DT_CONCLUSAO ,ETA_lea ,ATA_lea ,DDP.DT_CONCLUSAO,CANAL_lea,/*NF.EMISSAO,*/
	EP.DT_CONCLUSAO, convert(datetime,CXA.dt_pgto_rcto_hea,105) , DI.Data_PO_hea,
	Doc_F.Dt_Conclusao, ENT_PLAN.Dt_Conclusao, convert(datetime,CX_PRE.Dt_Pgto_Rcto_hea,105), DOC_CAMB.Dt_Conclusao,
	PG.Apelido,LLP.courier_Number_Lea

union all

select 
	hou.num_proc_hem Processo,
	convert(datetime,dt_emis_hem,105) Emissao, 
	Ordem.numero_po_hem Order_Number,
	PO.numero_po_hem PO_Number,
	Nome_Local Destino,/*Invoice.numero_po_hem Invoice,Invoice.Data_po_hem Invoice_Date,*/
	ETD_lem ETD,
	ATD_lem ATD,
	PA.DT_CONCLUSAO PRE_ALERT,
	ETA_lem ETA,
	ATA_lem ATA,
	min(convert(datetime,CT_ADI.Dt_Ins_hem, 105)) Dt_Cta_Adi,
	min(convert(datetime,CX_ADI.Dt_Pgto_Rcto_hem, 105)) Dt_CXA_Adi,
	DDP.DT_CONCLUSAO DDP,
	CANAL_lem CANAL,
	ENT_PLAN.Dt_Conclusao Ent_Planta,
	isnull(dbo.FBusca_DtNota(hou.num_proc_hem),dbo.FBusca_DtNota(LLP.courier_Number_Lem)) EMISSAO_NF,
	--NF.EMISSAO EMISSAO_NF,
	MAX(DATA_PC) DATA_PRESTACAO,
	convert(datetime,CXA.dt_pgto_rcto_hem,105) Receipt_Date, 
	DI.Data_PO_hem Data_DI,
	Doc_F.Dt_Conclusao Doc_F,
	convert(datetime,CX_PRE.Dt_Pgto_Rcto_hem,105) Dt_PRE_Adi,
	DOC_CAMB.Dt_Conclusao Doc_Cambio,
	Sum (CX_ADI.vlr_pgto_rcto_hem) Valor_Adiant,
	dbo.fBusca_Tarefa(hou.num_proc_hem,35) Receb_Fatura,
	PG.Apelido										Nome_Grupo
from 
	house_exp_mar hou
	Left Join Po_hem Ordem on HOU.Num_proc_hem=Ordem.num_proc_hem and Ordem.ID_DC=3
	Left Join Po_hem PO on HOU.Num_proc_hem=PO.num_proc_hem and PO.ID_DC=1
	Join Localidade DST on DST.cd_local=cd_dst_hem
	--Left Join Po_hem Invoice on HOU.Num_proc_hem=Invoice.num_proc_hem and Invoice.ID_DC=2
	Join LLp_exp_mar LLP on LLp.num_proc_lem=hou.num_proc_hem
	Left Join Tarefas_Processos PA on HOU.NUM_PROC_hem=PA.NUM_PROC AND PA.ID_TASK=1
	Left Join Tarefas_Processos DDP on HOU.NUM_PROC_hem=DDP.NUM_PROC AND DDP.ID_TASK=4
	LEFT JOIN CTA_CTE_HOU_exp_mar CTA ON HOU.NUM_PROC_hem=CTA.NUM_PROC_hem AND CTA.DC_hem='C' AND CTA.CD_TP_TX='BRO'
	LEFT JOIN CAIXA_HOU_exp_mar CXA ON HOU.NUM_PROC_hem=CXA.NUM_PROC_hem AND CXA.DC_hem='C' AND CXA.CD_TP_TX='BRO'
	LEFT JOIN CTA_CTE_HOU_exp_mar CT_ADI ON HOU.NUM_PROC_hem=CT_ADI.NUM_PROC_hem AND CT_ADI.DC_hem='C' AND CT_ADI.CD_TP_TX in ('XB2','XB3','XBA','XBC')
	LEFT JOIN CAIXA_HOU_exp_mar  CX_ADI ON HOU.NUM_PROC_hem=CX_ADI.NUM_PROC_hem AND CX_ADI.DC_hem='C' AND CX_ADI.CD_TP_TX in ('XB2','XB3','XBA','XBC')
	LEFT JOIN CAIXA_HOU_exp_mar  CX_PRE ON HOU.NUM_PROC_hem=CX_PRE.NUM_PROC_hem AND CX_PRE.CD_TP_TX in (select cd_tp_Tx from tipo_taxa where nome_tp_tx like 'Adiantamento%' and left(cd_tp_tx,1)='X')
	--LEFT JOIN BASE_NOTA_FISCAL NF ON CTA.NUM_NF_hem=NF.NOTA_FISCAL AND CTA.REF_ACESSO_NF_hem=NF.REF_ACESSO
	LEFT JOIN FATURA_CHB FAT ON HOU.NUM_PROC_hem=PROCESSO_PC or HOU.NUM_PROC_mem=PROCESSO_PC
	Left Join Tarefas_Processos EP on HOU.NUM_PROC_hem=EP.NUM_PROC AND EP.ID_TASK=4
	Left Join Po_hem DI on HOU.Num_proc_hem=DI.num_proc_hem and DI.ID_DC=5
	Left Join Tarefas_Processos ENT_PLAN on HOU.NUM_PROC_hem=ENT_PLAN.NUM_PROC AND ENT_PLAN.ID_TASK=13
	Left Join Tarefas_Processos DOC_F on HOU.NUM_PROC_hem=DOC_F.NUM_PROC AND DOC_F.ID_TASK=26
	Left Join Tarefas_Processos DOC_CAMB on HOU.NUM_PROC_hem=DOC_CAMB.NUM_PROC AND DOC_CAMB.ID_TASK=23
	join Grupo G on G.grupo= right(left(HOU.Num_Proc_Hem,5),3)
	join pessoa PG on PG.cd_pes=G.cd_pes_grupo
	Left Join Hist_Geral CANC on CANC.HSGProcesso=HOU.Num_Proc_HEM and CANC.Cd_Tp_Ocor='28'
WHERE
	CANC.HSGProcesso is null
GROUP BY 
	hou.num_proc_hem ,convert(datetime,dt_emis_hem,105) , Ordem.numero_po_hem ,
	PO.numero_po_hem ,Nome_Local ,/*Invoice.numero_po_hem ,Invoice.Data_po_hem ,*/
	ETD_lem ,ATD_lem ,PA.DT_CONCLUSAO ,ETA_lem ,ATA_lem ,DDP.DT_CONCLUSAO,CANAL_lem,/*NF.EMISSAO,*/
	EP.DT_CONCLUSAO, convert(datetime,CXA.dt_pgto_rcto_hem,105) , DI.Data_PO_hem,
	Doc_F.Dt_Conclusao, ENT_PLAN.Dt_Conclusao, convert(datetime,CX_PRE.Dt_Pgto_Rcto_hem,105), DOC_CAMB.Dt_Conclusao,
	PG.Apelido,LLP.courier_Number_Lem

union all

select 
	hou.num_proc_heo Processo,
	convert(datetime,dt_emis_heo,105) Emissao, 
	Ordem.numero_po_heo Order_Number,
	PO.numero_po_heo PO_Number,
	Nome_Local Destino,/*Invoice.numero_po_heo Invoice,Invoice.Data_po_heo Invoice_Date,*/
	ETD_leo ETD,
	ATD_leo ATD,
	PA.DT_CONCLUSAO PRE_ALERT,
	ETA_leo ETA,
	ATA_leo ATA,
	min(convert(datetime,CT_ADI.Dt_Ins_heo, 105)) Dt_Cta_Adi,
	min(convert(datetime,CX_ADI.Dt_Pgto_Rcto_heo, 105)) Dt_CXA_Adi,
	DDP.DT_CONCLUSAO DDP,
	CANAL_leo CANAL,
	ENT_PLAN.Dt_Conclusao Ent_Planta,
	isnull(dbo.FBusca_DtNota(hou.num_proc_heo),dbo.FBusca_DtNota(LLP.courier_Number_Leo)) EMISSAO_NF,
	--NF.EMISSAO EMISSAO_NF,
	MAX(DATA_PC) DATA_PRESTACAO,
	convert(datetime,CXA.dt_pgto_rcto_heo,105) Receipt_Date, 
	DI.Data_PO_heo Data_DI,
	Doc_F.Dt_Conclusao Doc_F,
	convert(datetime,CX_PRE.Dt_Pgto_Rcto_heo,105) Dt_PRE_Adi,
	DOC_CAMB.Dt_Conclusao Doc_Cambio,
	Sum (CX_ADI.vlr_pgto_rcto_heo) Valor_Adiant,
	dbo.fBusca_Tarefa(hou.num_proc_heo,35) Receb_Fatura,
	PG.Apelido										Nome_Grupo
from 
	house_exp_out hou
	Left Join Po_heo Ordem on HOU.Num_proc_heo=Ordem.num_proc_heo and Ordem.ID_DC=3
	Left Join Po_heo PO on HOU.Num_proc_heo=PO.num_proc_heo and PO.ID_DC=1
	Join Localidade DST on DST.cd_local=cd_dst_heo
	--Left Join Po_heo Invoice on HOU.Num_proc_heo=Invoice.num_proc_heo and Invoice.ID_DC=2
	Join LLp_exp_out LLP on LLp.num_proc_leo=hou.num_proc_heo
	Left Join Tarefas_Processos PA on HOU.NUM_PROC_heo=PA.NUM_PROC AND PA.ID_TASK=1
	Left Join Tarefas_Processos DDP on HOU.NUM_PROC_heo=DDP.NUM_PROC AND DDP.ID_TASK=4
	LEFT JOIN CTA_CTE_HOU_exp_out CTA ON HOU.NUM_PROC_heo=CTA.NUM_PROC_heo AND CTA.DC_heo='C' AND CTA.CD_TP_TX='BRO'
	LEFT JOIN CAIXA_HOU_exp_out CXA ON HOU.NUM_PROC_heo=CXA.NUM_PROC_heo AND CXA.DC_heo='C' AND CXA.CD_TP_TX='BRO'
	LEFT JOIN CTA_CTE_HOU_exp_out CT_ADI ON HOU.NUM_PROC_heo=CT_ADI.NUM_PROC_heo AND CT_ADI.DC_heo='C' AND CT_ADI.CD_TP_TX in ('XB2','XB3','XBA','XBC')
	LEFT JOIN CAIXA_HOU_exp_out  CX_ADI ON HOU.NUM_PROC_heo=CX_ADI.NUM_PROC_heo AND CX_ADI.DC_heo='C' AND CX_ADI.CD_TP_TX in ('XB2','XB3','XBA','XBC')
	LEFT JOIN CAIXA_HOU_exp_out  CX_PRE ON HOU.NUM_PROC_heo=CX_PRE.NUM_PROC_heo AND CX_PRE.CD_TP_TX in ((select cd_tp_Tx from tipo_taxa where nome_tp_tx like 'Adiantamento%' and left(cd_tp_tx,1)='X'))
	--LEFT JOIN BASE_NOTA_FISCAL NF ON CTA.NUM_NF_heo=NF.NOTA_FISCAL AND CTA.REF_ACESSO_NF_heo=NF.REF_ACESSO
	LEFT JOIN FATURA_CHB FAT ON HOU.NUM_PROC_heo=PROCESSO_PC
	Left Join Tarefas_Processos EP on HOU.NUM_PROC_heo=EP.NUM_PROC AND EP.ID_TASK=4
	Left Join Po_heo DI on HOU.Num_proc_heo=DI.num_proc_heo and DI.ID_DC=5
	Left Join Tarefas_Processos ENT_PLAN on HOU.NUM_PROC_heo=ENT_PLAN.NUM_PROC AND ENT_PLAN.ID_TASK=13
	Left Join Tarefas_Processos DOC_F on HOU.NUM_PROC_heo=DOC_F.NUM_PROC AND DOC_F.ID_TASK=26
	Left Join Tarefas_Processos DOC_CAMB on HOU.NUM_PROC_heo=DOC_CAMB.NUM_PROC AND DOC_CAMB.ID_TASK=23
	join Grupo G on G.grupo= right(left(HOU.Num_Proc_Heo,5),3)
	join pessoa PG on PG.cd_pes=G.cd_pes_grupo
	Left Join Hist_Geral CANC on CANC.HSGProcesso=HOU.Num_Proc_HEO and CANC.Cd_Tp_Ocor='28'
WHERE
	CANC.HSGProcesso is null
GROUP BY 
	hou.num_proc_heo ,convert(datetime,dt_emis_heo,105) , Ordem.numero_po_heo ,
	PO.numero_po_heo ,Nome_Local ,/*Invoice.numero_po_heo ,Invoice.Data_po_heo ,*/
	ETD_leo ,ATD_leo ,PA.DT_CONCLUSAO ,ETA_leo ,ATA_leo ,DDP.DT_CONCLUSAO,CANAL_leo,/*NF.EMISSAO,*/
	EP.DT_CONCLUSAO, convert(datetime,CXA.dt_pgto_rcto_heo,105) , DI.Data_PO_heo,
	Doc_F.Dt_Conclusao, ENT_PLAN.Dt_Conclusao, convert(datetime,CX_PRE.Dt_Pgto_Rcto_heo,105), DOC_CAMB.Dt_Conclusao, PG.Apelido,
	LLP.courier_Number_Leo














GO
