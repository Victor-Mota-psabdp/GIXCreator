SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--spFMCTEMP_Ins 34,'2008-01-01','2008-10-24'



CREATE procedure [dbo].[spFMCTEMP_Ins] 

	@ID	int,
	@DataInicial	datetime,
	@DataFinal		datetime

AS

Insert FMC_TMP

	select distinct
		@ID,cxa.cd_tp_tx,cxa.num_proc_him,vlr_pgto_rcto_him,REF_CTB_TX
	from 
		caixa_hou_imp_mar CXA
		Join House_Imp_mar hou on hou.num_proc_him=cxa.num_proc_him
		LEft Join Adiantamento_Cliente AC on CXA.num_proc_him=AC.num_proc 
		Left Join Adiantamento_Cliente_Det ACD on AC.ID=ACD.id and ACD.cd_tp_tx=CXA.cd_tp_Tx
		LEFT JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
		Left Join Fatura_CHB FAT on processo_pc=hou.num_proC_him
	--	Left Join FMC_TMP FMC on FMC.num_proc=cxa.num_proc_him and cxa.cd_tp_Tx=fmc.cd_tp_Tx
	Where
		hou.num_proc_him like '%FMC%' 
		and convert(datetime,Dt_Pgto_Rcto_HIM,105) between @DataInicial and @DataFinal and
		(
		( cxa.dc_him='D' and acd.id is null and REF_CTB_TX not in ('XBA','BRO'))
		OR
		( cxa.dc_him='C' and acd.id is null and REF_CTB_TX in ('XBA') AND REF_CTB_TX NOT IN ('BRO'))
		)
		and processo_pc is  null

UNION

	select distinct
		@ID,cxa.cd_tp_tx,cxa.num_proc_hia,vlr_pgto_rcto_hia,REF_CTB_TX 
	from 
		caixa_hou_imp_aer CXA
		Join House_Imp_aer hou on hou.num_proc_hia=cxa.num_proc_hia
		LEft Join Adiantamento_Cliente AC on CXA.num_proc_hia=AC.num_proc 
		Left Join Adiantamento_Cliente_Det ACD on AC.ID=ACD.id and ACD.cd_tp_tx=CXA.cd_tp_Tx
		LEFT JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
	--	Left Join FMC_TMP FMC on FMC.num_proc=cxa.num_proc_hia and cxa.cd_tp_Tx=fmc.cd_tp_Tx
		Left Join Fatura_CHB FAT on FAT.processo_pc=hou.num_proc_hia
	Where
		hou.num_proc_hia like '%FMC%'
		and convert(datetime,Dt_Pgto_Rcto_HIA,105) between @DataInicial and @DataFinal and
		(
		( cxa.dc_hia='D' and acd.id is null and REF_CTB_TX not in ('XBA','BRO'))
		OR
		( cxa.dc_hia='C' and acd.id is null and REF_CTB_TX in ('XBA') AND REF_CTB_TX NOT IN ('BRO'))
		)
		and
			processo_pc is null
UNION
	select distinct
		@ID,cxa.cd_tp_tx,cxa.num_proc_hio,vlr_pgto_rcto_hio,REF_CTB_TX 
	from 
		caixa_hou_imp_out CXA
		Join House_Imp_out hou on hou.num_proc_hio=cxa.num_proc_hio
		LEft Join Adiantamento_Cliente AC on CXA.num_proc_hio=AC.num_proc 
		Left Join Adiantamento_Cliente_Det ACD on AC.ID=ACD.id and ACD.cd_tp_tx=CXA.cd_tp_Tx
		LEFT JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
	--	Left Join FMC_TMP FMC on FMC.num_proc=cxa.num_proc_hio and cxa.cd_tp_Tx=fmc.cd_tp_Tx
		Left Join Fatura_CHB fat on processo_pc=hou.num_proc_hio
	Where
		hou.num_proc_hio like '%FMC%'
		and convert(datetime,Dt_Pgto_Rcto_HIO,105) between @DataInicial and @DataFinal and
		(
		( cxa.dc_hio='D' and acd.id is null and REF_CTB_TX not in ('XBA','BRO'))
		OR
		( cxa.dc_hio='C' and acd.id is null and REF_CTB_TX in ('XBA') AND REF_CTB_TX NOT IN ('BRO'))
		)
		and processo_pc is null

UNION
	select distinct
		@ID,cxa.cd_tp_tx,cxa.num_proc_HEM,vlr_pgto_rcto_HEM,REF_CTB_TX 
	from 
		caixa_hou_EXP_mar CXA
		Join House_EXP_mar hou on hou.num_proc_HEM=cxa.num_proc_HEM
		LEft Join Adiantamento_Cliente AC on CXA.num_proc_HEM=AC.num_proc 
		Left Join Adiantamento_Cliente_Det ACD on AC.ID=ACD.id and ACD.cd_tp_tx=CXA.cd_tp_Tx
		LEFT JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
	--	Left Join FMC_TMP FMC on FMC.num_proc=cxa.num_proc_HEM and cxa.cd_tp_Tx=fmc.cd_tp_Tx
		Left Join Fatura_CHB on Processo_PC=hou.num_proc_hem
	Where
		hou.num_proc_HEM like '%FMC%'
		and convert(datetime,Dt_Pgto_Rcto_HEM,105) between @DataInicial and @DataFinal and 
		(
		( cxa.dc_hem='D' and acd.id is null and REF_CTB_TX not in ('XBA','BRO'))
		OR
		( cxa.dc_hem='C' and acd.id is null and REF_CTB_TX in ('XBA') AND REF_CTB_TX NOT IN ('BRO'))
		)
		and
		processo_pc is not null

UNION
	select distinct
		@ID,cxa.cd_tp_tx,cxa.num_proc_HEA,vlr_pgto_rcto_HEA,REF_CTB_TX 
	from 
		caixa_hou_EXP_aer CXA
		Join House_EXP_aer hou on hou.num_proc_HEA=cxa.num_proc_HEA
		LEft Join Adiantamento_Cliente AC on CXA.num_proc_HEA=AC.num_proc 
		Left Join Adiantamento_Cliente_Det ACD on AC.ID=ACD.id and ACD.cd_tp_tx=CXA.cd_tp_Tx
		LEFT JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
	--	Left Join FMC_TMP FMC on FMC.num_proc=cxa.num_proc_HEA and cxa.cd_tp_Tx=fmc.cd_tp_Tx
		Left Join Fatura_CHB FAT on processo_pc=hou.num_proc_hea
	Where
		hou.num_proc_HEA like '%FMC%'
		and convert(datetime,Dt_Pgto_Rcto_HEA,105) between @DataInicial and @DataFinal and
		(
		( cxa.dc_hea='D' and acd.id is null and REF_CTB_TX not in ('XBA','BRO'))
		OR
		( cxa.dc_hea='C' and acd.id is null and REF_CTB_TX in ('XBA') AND REF_CTB_TX IN ('BRO'))
		) 
		and processo_pc is null

UNION
	select distinct
		@ID,cxa.cd_tp_tx,cxa.num_proc_HEO,vlr_pgto_rcto_HEO,REF_CTB_TX 
	from 
		caixa_hou_EXP_out CXA
		Join House_EXP_out hou on hou.num_proc_HEO=cxa.num_proc_HEO
		LEft Join Adiantamento_Cliente AC on CXA.num_proc_HEO=AC.num_proc 
		Left Join Adiantamento_Cliente_Det ACD on AC.ID=ACD.id and ACD.cd_tp_tx=CXA.cd_tp_Tx
		LEFT JOIN TIPO_TAXA TT ON TT.CD_TP_TX=CXA.CD_TP_TX
	--	Left Join FMC_TMP FMC on FMC.num_proc=cxa.num_proc_HEO and cxa.cd_tp_Tx=fmc.cd_tp_Tx
		Left Join Fatura_CHB FAT on processo_pc=hou.num_proc_heo
	Where
		hou.num_proc_HEO like '%FMC%' 
		and convert(datetime,Dt_Pgto_Rcto_HEO,105) between @DataInicial and @DataFinal and
		(
		( cxa.dc_heo='D' and acd.id is null and REF_CTB_TX not in ('XBA','BRO'))
		OR
		( cxa.dc_heo='C' and acd.id is null and REF_CTB_TX in ('XBA') AND REF_CTB_TX NOT IN ('BRO'))
		) 
		and Processo_pc is null


union

--CTA_CTE

	select distinct
		@ID,CTA.cd_tp_tx,CTA.num_proc_him,VLR_ORG_HIM,REF_CTB_TX
	from 
		Cta_Cte_hou_imp_mar Cta
		Left Join Caixa_hou_imp_MAR CXA on CTA.num_proc_him=CXA.num_proc_him and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_him=CXA.dc_him
		Join House_Imp_mar hou on hou.num_proc_him=cta.num_proc_him
		LEft Join Adiantamento_Cliente AC on cta.num_proc_him=AC.num_proc 
		Left Join Adiantamento_Cliente_Det ACD on AC.ID=ACD.id and ACD.cd_tp_tx=cta.cd_tp_Tx
		LEFT JOIN TIPO_TAXA TT ON TT.CD_TP_TX=cta.CD_TP_TX
	--	Left Join FMC_TMP FMC on FMC.num_proc=cxa.num_proc_him and cxa.cd_tp_Tx=fmc.cd_tp_Tx
		Left Join Fatura_CHB FAT on processo_pc=hou.num_proc_him
	Where
		hou.num_proc_him like '%FMC%' 
		and convert(datetime,dt_ins_him,105) between @DataInicial and @DataFinal and
		 REF_CTB_TX='BRO' and cta.dc_him='C'
			and processo_pc is null
union

	select distinct
		@ID,CTA.cd_tp_tx,CTA.num_proc_hem,VLR_ORG_HeM,REF_CTB_TX
	from 
		Cta_Cte_hou_exp_mar Cta
		Left Join Caixa_hou_exp_MAR CXA on CTA.num_proc_hem=CXA.num_proc_hem and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hem=CXA.dc_hem
		Join House_Exp_mar hou on hou.num_proc_hem=cta.num_proc_hem
		LEft Join Adiantamento_Cliente AC on cta.num_proc_hem=AC.num_proc 
		Left Join Adiantamento_Cliente_Det ACD on AC.ID=ACD.id and ACD.cd_tp_tx=cta.cd_tp_Tx
		LEFT JOIN TIPO_TAXA TT ON TT.CD_TP_TX=cta.CD_TP_TX
	--	Left Join FMC_TMP FMC on FMC.num_proc=cxa.num_proc_him and cxa.cd_tp_Tx=fmc.cd_tp_Tx
		Left Join Fatura_CHB fat on processo_pc=hou.num_proc_hem
	Where
		hou.num_proc_hem like '%FMC%' 
		and convert(datetime,dt_ins_hem,105) between @DataInicial and @DataFinal and
		 REF_CTB_TX='BRO' and cta.dc_hem='C'
		and processo_pc is null


UNION

	select distinct
		@ID,CTA.cd_tp_tx,CTA.num_proc_hia,VLR_ORG_hia,REF_CTB_TX
	from 
		Cta_Cte_hou_imp_AER Cta
		Left Join Caixa_hou_imp_AER CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hia=CXA.dc_hia
		Join House_Imp_AER hou on hou.num_proc_hia=cta.num_proc_hia
		LEft Join Adiantamento_Cliente AC on cta.num_proc_hia=AC.num_proc 
		Left Join Adiantamento_Cliente_Det ACD on AC.ID=ACD.id and ACD.cd_tp_tx=cta.cd_tp_Tx
		LEFT JOIN TIPO_TAXA TT ON TT.CD_TP_TX=cta.CD_TP_TX
	--	Left Join FMC_TMP FMC on FMC.num_proc=cxa.num_proc_hia and cxa.cd_tp_Tx=fmc.cd_tp_Tx
		Left Join Fatura_CHB FAT on processo_pc=hou.num_proc_hia
	Where
		hou.num_proc_hia like '%FMC%' 
		and convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal and
		 REF_CTB_TX='BRO' and cta.dc_hia='C'
		and processo_pc is null
union

	select distinct
		@ID,CTA.cd_tp_tx,CTA.num_proc_hea,VLR_ORG_hea,REF_CTB_TX
	from 
		Cta_Cte_hou_exp_AER Cta
		Left Join Caixa_hou_exp_AER CXA on CTA.num_proc_hea=CXA.num_proc_hea and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hea=CXA.dc_hea
		Join House_Exp_AER hou on hou.num_proc_hea=cta.num_proc_hea
		LEft Join Adiantamento_Cliente AC on cta.num_proc_hea=AC.num_proc 
		Left Join Adiantamento_Cliente_Det ACD on AC.ID=ACD.id and ACD.cd_tp_tx=cta.cd_tp_Tx
		LEFT JOIN TIPO_TAXA TT ON TT.CD_TP_TX=cta.CD_TP_TX
	--	Left Join FMC_TMP FMC on FMC.num_proc=cxa.num_proc_hia and cxa.cd_tp_Tx=fmc.cd_tp_Tx
		Left Join Fatura_CHB FAT on FAT.processo_pc=hou.num_proc_hea
	Where
		hou.num_proc_hea like '%FMC%' 
		and convert(datetime,dt_ins_hea,105) between @DataInicial and @DataFinal and
		 REF_CTB_TX='BRO' and cta.dc_hea='C'
		and processo_pc is null

UNION

	select distinct
		@ID,CTA.cd_tp_tx,CTA.num_proc_HIO,VLR_ORG_HIO,REF_CTB_TX
	from 
		Cta_Cte_hou_imp_OUT Cta
		Left Join Caixa_hou_imp_OUT CXA on CTA.num_proc_HIO=CXA.num_proc_HIO and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_HIO=CXA.dc_HIO
		Join House_Imp_OUT hou on hou.num_proc_HIO=cta.num_proc_HIO
		LEft Join Adiantamento_Cliente AC on cta.num_proc_HIO=AC.num_proc 
		Left Join Adiantamento_Cliente_Det ACD on AC.ID=ACD.id and ACD.cd_tp_tx=cta.cd_tp_Tx
		LEFT JOIN TIPO_TAXA TT ON TT.CD_TP_TX=cta.CD_TP_TX
	--	Left Join FMC_TMP FMC on FMC.num_proc=cxa.num_proc_HIO and cxa.cd_tp_Tx=fmc.cd_tp_Tx
		Left Join Fatura_CHB on processo_pc=hou.num_proc_hio
	Where
		hou.num_proc_HIO like '%FMC%' 
		and convert(datetime,dt_ins_HIO,105) between @DataInicial and @DataFinal and
		 REF_CTB_TX='BRO' and cta.dc_hio='C'
		and processo_pc is null
union

	select distinct
		@ID,CTA.cd_tp_tx,CTA.num_proc_HEO,VLR_ORG_HEO,REF_CTB_TX
	from 
		Cta_Cte_hou_exp_OUT Cta
		Left Join Caixa_hou_exp_OUT CXA on CTA.num_proc_HEO=CXA.num_proc_HEO and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_HEO=CXA.dc_HEO
		Join House_Exp_OUT hou on hou.num_proc_HEO=cta.num_proc_HEO
		LEft Join Adiantamento_Cliente AC on cta.num_proc_HEO=AC.num_proc 
		Left Join Adiantamento_Cliente_Det ACD on AC.ID=ACD.id and ACD.cd_tp_tx=cta.cd_tp_Tx
		LEFT JOIN TIPO_TAXA TT ON TT.CD_TP_TX=cta.CD_TP_TX
	--	Left Join FMC_TMP FMC on FMC.num_proc=cxa.num_proc_HIO and cxa.cd_tp_Tx=fmc.cd_tp_Tx
		Left Join Fatura_CHB on processo_pc=hou.num_proc_heo
	Where
		hou.num_proc_HEO like '%FMC%' 
		and convert(datetime,dt_ins_HEO,105) between @DataInicial and @DataFinal and
		 REF_CTB_TX='BRO' and cta.dc_heo='C'
		and processo_pc is null



GO
