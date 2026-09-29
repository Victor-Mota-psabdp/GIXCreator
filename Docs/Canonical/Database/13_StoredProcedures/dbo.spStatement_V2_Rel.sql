SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spStatement_V2_Rel] '2016-01-01','2017-08-11','2017-08-11','%','A'
--[spStatement_Rel] '01-01-2017','08-11-2017','08-11-2017','%','O'
CREATE Procedure [dbo].[spStatement_V2_Rel]
	@DataInicial	datetime,
	@DataFinal		datetime,
	@DataPgto		datetime,
	@Agente			Varchar(30),
	@Tipo			varChar(50)

AS

if @Agente = ''
 set @Agente = '%'
 
set @Tipo = LEFT(@Tipo,1)

If @Tipo='A'	
	BEGIN
		select 
			AX.id_Ax AX_ID, Dt_Ins_Hia Data,MAWB_HIA MAWB_MIA, CTA.Num_Proc_hia,Apelido,Nome_tp_TX_ing,Hawb_Hia,Nome_tp_Moeda,cta.dc_hia,vlr_org_hia,isnull(CAST(Num_DCN_HIA AS cHAR(17)),fatcod) Num_DCN_HIA,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_imp_aer CTA with(nolock)
			Join House_Imp_Aer HOU with(nolock) on hou.num_proc_hia=cta.num_proc_hia
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hia=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIA=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hia
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hia=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hia=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hia)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIA=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIA=ax.dc 
		Where
			cd_Tp_Ativ='AGT' and desp_org_hia='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_hia,103) between @DataInicial and @DataFinal
			and apelido like @Agente	

		UNION ALL

		select 
			AX.id_Ax AX_ID,Dt_Ins_Hea Data, MAWB_HEA,CTA.Num_Proc_Hea,Apelido,Nome_tp_TX_ing,Hawb_hea,Nome_tp_Moeda,cta.dc_hea,vlr_org_hea,isnull(fatcod,Num_DCN_hea) Num_DCN_hea,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_exp_aer CTA with(nolock)
			Join House_exp_Aer HOU with(nolock) on hou.num_proc_hea=cta.num_proc_hea
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hea=CXA.Num_Proc_HIA AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_hea=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HIA,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hea
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Exp_Aer mas on mas.num_proc_mea=hou.num_proc_mea
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hea=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hea=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hea)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEA=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEA=ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_DST_hea='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_hea,103) between @DataInicial and @DataFinal
			and apelido like @Agente
	
		UNION ALL

		select 
			AX.id_Ax AX_ID, Dt_Ins_Him Data,MAWB_HIM,CTA.num_proc_Him,Apelido,Nome_tp_TX_ing,Hawb_HIM,Nome_tp_Moeda,cta.dc_HIM,vlr_org_HIM,isnull( cast(Num_DCN_HIM as char(17)),fatcod) Num_DCN_HIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_imp_MAR CTA with(nolock)
			Join House_Imp_MAR HOU with(nolock) on hou.num_proc_HIM=cta.num_proc_HIM
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_HIM=CXA.num_proc_HIa AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIM=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HIA,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_HIM
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Imp_Mar mas on mas.num_proc_mim=hou.num_proc_mim
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_him=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_him=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_him)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIM=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIM=ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_HIM='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_HIM,103) between @DataInicial and @DataFinal
			and apelido like @Agente	

		UNION ALL

		select 
			AX.id_Ax AX_ID, Dt_Ins_Hem Data, MAWB_HEM,CTA.num_proc_hem,Apelido,Nome_tp_TX_ing,Hawb_HEM,Nome_tp_Moeda,cta.dc_HEM,vlr_org_HEM,cast(isnull(cast(Num_DCN_HEM as char(17)),fatcod) as varchar(17)) Num_DCN_HEM ,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_exp_MAR CTA with(nolock)
			Join House_exp_MAR HOU with(nolock) on hou.num_proc_HEM=cta.num_proc_HEM
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_HEM=CXA.num_proc_Hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HEM=CXA.DC_Hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HIA,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_HEM
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Exp_Mar mas on mas.num_proc_mem=hou.num_proc_mem
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hem=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hem=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hem)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEM=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEM=ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_DST_HEM='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_HEM,103) between @DataInicial and @DataFinal
			and apelido like @Agente	

		Union All

		select 
			AX.id_Ax AX_ID,Dt_Ins_Hio Data,MAWB_HIO MAWB_MIA, CTA.Num_Proc_hio,Apelido,Nome_tp_TX_ing,Hawb_Hio,Nome_tp_Moeda,cta.dc_hio,vlr_org_hio,isnull(CAST(Num_DCN_HIO AS cHAR(17)),fatcod) Num_DCN_HIO,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_imp_out CTA with(nolock)
			Join House_Imp_OUT HOU with(nolock) on hou.num_proc_hio=cta.num_proc_hio
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hio=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIO=CXA.DC_HIa and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HIA,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hio
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hio=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hio=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hio)
			Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIO=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIO=ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_hio='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_hio,103) between @DataInicial and @DataFinal
			and apelido like @Agente
		
		Union All
			
		select 
			AX.id_Ax AX_ID,Dt_Ins_Heo Data,MAWB_HEO MAWB_MIA, CTA.Num_Proc_heo,Apelido,Nome_tp_TX_ing,Hawb_Heo,Nome_tp_Moeda,cta.dc_heo,vlr_org_heo,isnull(CAST(Num_DCN_HEO AS cHAR(17)),fatcod) Num_DCN_HEO,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_exp_out CTA with(nolock)
			Join House_EXP_OUT HOU with(nolock) on hou.num_proc_heo=cta.num_proc_heo
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_heo=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HeO=CXA.DC_Hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_heo
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_heo=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_heo=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_heo)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEO=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEO=ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_heo='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_heo,103) between @DataInicial and @DataFinal
			and apelido like @Agente
--MASTER
		UNION ALL
		select 
			AX.id_Ax AX_ID, Dt_Ins_mia Data, MAWB_MIA, CTA.Num_Proc_mia,Apelido,Nome_tp_TX_ing,Mawb_mia,Nome_tp_Moeda,cta.dc_mia,vlr_org_mia,isnull(CAST(CTA.Num_DCN_MIA AS cHAR(17)),fatcod) Num_DCN_HIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_mas_imp_aer CTA with(nolock)
			Join Master_Imp_Aer HOU with(nolock) on hou.num_proc_mia=cta.num_proc_mia
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_mia=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIA=CXA.DC_hIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_mia
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_mia=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_mia=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_mia)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MIA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MIA=ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_mia='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_mia,103) between @DataInicial and @DataFinal
			and apelido like @Agente	

		UNION ALL
		select 
			AX.id_Ax AX_ID, Dt_Ins_MEA Data, MAWB_MEA,CTA.Num_Proc_MEA,Apelido,Nome_tp_TX_ing,Mawb_MEA,Nome_tp_Moeda,cta.dc_MEA,vlr_org_MEA,isnull(fatcod,CTA.Num_DCN_MEA) Num_DCN_MEA,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_MAS_exp_aer CTA with(nolock)
			Join MASTER_exp_Aer HOU with(nolock) on hou.num_proc_MEA=cta.num_proc_MEA
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MEA=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEA=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MEA
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_MEA=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_MEA=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_MEA)
			Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MEA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MEA=ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_DST_MEA='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_MEA,103) between @DataInicial and @DataFinal
			and apelido like @Agente

		UNION ALL
		select 
			AX.id_Ax AX_ID, Dt_Ins_MIM Data,MAWB_MIM,CTA.num_proc_MIM,Apelido,Nome_tp_TX_ing,Mawb_MIM,Nome_tp_Moeda,cta.dc_MIM,vlr_org_MIM,isnull( cast(CTA.Num_DCN_MIM as char(17)),fatcod) Num_DCN_MIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_MAS_imp_MAR CTA with(nolock)
			Join MASTER_Imp_MAR HOU with(nolock) on hou.num_proc_MIM=cta.num_proc_MIM
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MIM=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIM=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MIM
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_MIM=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_MIM=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_MIM)
			Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MIM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MIM=ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_MIM='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_MIM,103) between @DataInicial and @DataFinal
			and apelido like @Agente

		UNION ALL
		select 
			AX.id_Ax AX_ID,Dt_Ins_MEM Data, MAWB_MEM,CTA.num_proc_MEM,Apelido,Nome_tp_TX_ing,Mawb_MEM,Nome_tp_Moeda,cta.dc_MEM,vlr_org_MEM,cast(isnull(cast(CTA.Num_DCN_MEM as char(17)),fatcod) as varchar(17)) Num_DCN_MEM ,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_MAS_exp_MAR CTA with(nolock)
			Join MASTER_exp_MAR HOU with(nolock) on hou.num_proc_MEM=cta.num_proc_MEM
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MEM=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEM=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MEM
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_MEM=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_MEM=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_MEM)
			Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
				Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MEM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MEM  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_DST_MEM='N' and cxa.num_lcto is null
			and convert(datetime,dt_ins_MEM,103) between @DataInicial and @DataFinal
			and apelido like @Agente

	END
		
if @Tipo='O'
	BEGIN
		select 
			AX.id_Ax AX_ID,Dt_Ins_Hia Data,MAWB_HIA MAWB_MIA,CTA.Num_Proc_hia,Apelido,Nome_tp_TX_ing,Hawb_Hia,Nome_tp_Moeda,cta.dc_hia,vlr_org_hia,Num_DCN_HIA,cta.cd_tp_moeda,
			--CXA.Par_Moeda_HIA Paridade
			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
		From 
			cta_cte_hou_imp_aer CTA with(nolock)
			Join House_Imp_Aer HOU with(nolock) on hou.num_proc_hia=cta.num_proc_hia
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hia=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIA=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hia
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIA  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_hia='N' and cxa.num_lcto is NOT null
			and convert(datetime,dt_ins_hia,103) between @DataInicial and @DataFinal
			and apelido like @Agente	

		UNION ALL
		select 
			AX.id_Ax AX_ID,Dt_Ins_Hea Data, MAWB_HEA,CTA.Num_Proc_Hea,Apelido,Nome_tp_TX_ing,Hawb_hea,Nome_tp_Moeda,cta.dc_hea,vlr_org_hea,Num_DCN_hea,cta.cd_Tp_moeda,
			-- cxa.Par_Moeda_hea  Paridade
			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
		From 
			cta_cte_hou_exp_aer CTA with(nolock)
			Join House_exp_Aer HOU with(nolock) on hou.num_proc_hea=cta.num_proc_hea
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hea=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_hea=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hea
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Exp_Aer mas on mas.num_proc_mea=hou.num_proc_mea
			Left Join vwAXDocs AX on CTA.Num_Proc_HEA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEA  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_DST_hea='N' and cxa.num_lcto is NOT null
			and convert(datetime,dt_ins_hea,103) between @DataInicial and @DataFinal
			and apelido like @Agente

		UNION ALL

		select 
			AX.id_Ax AX_ID,Dt_Ins_Him Data,MAWB_HIM,CTA.num_proc_Him,Apelido,Nome_tp_TX_ing,Hawb_HIM,Nome_tp_Moeda,cta.dc_HIM,vlr_org_HIM,Num_DCN_HIM,cta.cd_tp_moeda,
			--CXA.Par_Moeda_him Paridade
			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
		From 
			cta_cte_hou_imp_MAR CTA with(nolock)
			Join House_Imp_MAR HOU with(nolock) on hou.num_proc_HIM=cta.num_proc_HIM
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_HIM=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIM=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_HIM
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIM  =ax.dc 

--			Join Master_Imp_Mar mas on mas.num_proc_mim=hou.num_proc_mim
		Where
			cd_Tp_Ativ='AGT' and desp_org_HIM='N' and cxa.num_lcto is NOT null
			and convert(datetime,dt_ins_HIM,103) between @DataInicial and @DataFinal
			and apelido like @Agente	

		UNION ALL

		select 
			AX.id_Ax AX_ID,Dt_Ins_Hem Data, MaWB_HEM,CTA.num_proc_hem,Apelido,Nome_tp_TX_ing,Hawb_HEM,Nome_tp_Moeda,cta.dc_HEM,vlr_org_HEM,Num_DCN_HEM ,cta.cd_Tp_moeda,
			--CXA.Par_Moeda_HEM Paridade
			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
		From 
			cta_cte_hou_exp_MAR CTA with(nolock)
			Join House_exp_MAR HOU with(nolock) on hou.num_proc_HEM=cta.num_proc_HEM
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_HEM=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HEM=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_HEM
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Exp_Mar mas on mas.num_proc_mem=hou.num_proc_mem
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEM  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_DST_HEM='N' and cxa.num_lcto is NOT null
			and convert(datetime,dt_ins_HEM,103) between @DataInicial and @DataFinal
			and apelido like @Agente

		Union All

	select 
			AX.id_Ax AX_ID,Dt_Ins_Hio Data,MAWB_HIO MAWB_MIA,CTA.Num_Proc_hio,Apelido,Nome_tp_TX_ing,Hawb_Hio,Nome_tp_Moeda,cta.dc_hio,vlr_org_hio,Num_DCN_HIO,cta.cd_tp_moeda,
			--CXA.Par_Moeda_HIO Paridade
			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
		From 
			cta_cte_hou_imp_out CTA with(nolock)
			Join House_Imp_OUT HOU with(nolock) on hou.num_proc_hio=cta.num_proc_hio
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hio=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIO=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hio
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
			Left Join vwAXDocs AX   with(nolock) on CTA.Num_Proc_HIO =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIO  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_hio='N' and cxa.num_lcto is NOT null
			and convert(datetime,dt_ins_hio,103) between @DataInicial and @DataFinal
			and apelido like @Agente

		Union All
		
	select 
			AX.id_Ax AX_ID,Dt_Ins_Heo Data,MAWB_HEO MAWB_MIA,CTA.Num_Proc_heo,Apelido,Nome_tp_TX_ing,Hawb_Heo,Nome_tp_Moeda,cta.dc_heo,vlr_org_heo,Num_DCN_HEO,cta.cd_tp_moeda,
			--CXA.Par_Moeda_HEO Paridade
			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
		From 
			cta_cte_hou_exp_out CTA with(nolock)
			Join House_Exp_OUT HOU with(nolock) on hou.num_proc_heo=cta.num_proc_heo
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_heo=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HEO=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_heo
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEO =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEO  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_heo='N' and cxa.num_lcto is NOT null
			and convert(datetime,dt_ins_heo,103) between @DataInicial and @DataFinal
			and apelido like @Agente	

--MASTER
		UNION ALL
		select 
			AX.id_Ax AX_ID,Dt_Ins_MIA Data,MAWB_MIA MAWB_MIA,CTA.Num_Proc_MIA,Apelido,Nome_tp_TX_ing,Mawb_MIA,Nome_tp_Moeda,cta.dc_MIA,vlr_org_MIA,CTA.Num_DCN_MIA,cta.cd_tp_moeda,
			--CXA.Par_Moeda_MIA Paridade
			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
		From 
			cta_cte_MAS_imp_aer CTA with(nolock)
			Join MASTER_Imp_Aer HOU with(nolock) on hou.num_proc_MIA=cta.num_proc_MIA
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MIA=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIA=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MIA
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MIA  =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MIA  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_MIA='N' and cxa.num_lcto is NOT null
			and convert(datetime,dt_ins_MIA,103) between @DataInicial and @DataFinal
			and apelido like @Agente	

		UNION ALL
		select 
			AX.id_Ax AX_ID,Dt_Ins_MEA Data, MAWB_MEA,CTA.Num_Proc_MEA,Apelido,Nome_tp_TX_ing,Mawb_MEA,Nome_tp_Moeda,cta.dc_MEA,vlr_org_MEA,CTA.Num_DCN_MEA,cta.cd_Tp_moeda,
			--cxa.Par_Moeda_MEA  Paridade
			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
		From 
			cta_cte_MAS_exp_aer CTA with(nolock)
			Join MASTER_EXP_Aer HOU with(nolock) on hou.num_proc_MEA=cta.num_proc_MEA
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MEA=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEA=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MEA
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MEA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MEA  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_DST_MEA='N' and cxa.num_lcto is NOT null
			and convert(datetime,dt_ins_MEA,103) between @DataInicial and @DataFinal
			and apelido like @Agente

		UNION ALL
		select 
			AX.id_Ax AX_ID,Dt_Ins_MIM Data,MAWB_MIM,CTA.num_proc_MIM,Apelido,Nome_tp_TX_ing,Mawb_MIM,Nome_tp_Moeda,cta.dc_MIM,vlr_org_MIM,CTA.Num_DCN_MIM,cta.cd_tp_moeda,
			--CXA.Par_Moeda_MIM Paridade
			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
		From 
			cta_cte_MAS_imp_MAR CTA with(nolock)
			Join MASTER_Imp_MAR HOU with(nolock) on hou.num_proc_MIM=cta.num_proc_MIM
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MIM=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIM=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MIM
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MIM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MIM  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_org_MIM='N' and cxa.num_lcto is NOT null
			and convert(datetime,dt_ins_MIM,103) between @DataInicial and @DataFinal
			and apelido like @Agente

		UNION ALL
		select 
			AX.id_Ax AX_ID,Dt_Ins_MEM Data, MaWB_MEM,CTA.num_proc_MEM,Apelido,Nome_tp_TX_ing,Mawb_MEM,Nome_tp_Moeda,cta.dc_MEM,vlr_org_MEM,CTA.Num_DCN_MEM ,cta.cd_Tp_moeda,
			--CXA.Par_Moeda_MEM Paridade
			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
		From 
			cta_cte_MAS_exp_MAR CTA with(nolock)
			Join MASTER_exp_MAR HOU with(nolock) on hou.num_proc_MEM=cta.num_proc_MEM
			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MEM=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEM=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MEM
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MEM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MEM  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' and desp_DST_MEM='N' and cxa.num_lcto is NOT null
			and convert(datetime,dt_ins_MEM,103) between @DataInicial and @DataFinal
			and apelido like @Agente

	END
	
If @Tipo='T'
	BEGIN
		select 
			AX.id_Ax AX_ID, Dt_Ins_Hia Data,MAWB_HIA MAWB_MIA, CTA.Num_Proc_hia,Apelido,Nome_tp_TX_ing,Hawb_Hia,
			Nome_tp_Moeda,cta.dc_hia,vlr_org_hia,isnull(CAST(Num_DCN_HIA AS cHAR(17)),fatcod) Num_DCN_HIA,
			cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_imp_aer CTA with(nolock)
			Join House_Imp_Aer HOU with(nolock) on hou.num_proc_hia=cta.num_proc_hia			
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hia
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hia=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hia=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hia)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIA=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIA=ax.dc 
		Where
			cd_Tp_Ativ='AGT' 
			and desp_org_hia='N' 
			--and cxa.num_lcto is null
			and convert(datetime,dt_ins_hia,103) between @DataInicial and @DataFinal
			and apelido like @Agente	

		UNION ALL

		select 
			AX.id_Ax AX_ID,Dt_Ins_Hea Data, MAWB_HEA,CTA.Num_Proc_Hea,Apelido,Nome_tp_TX_ing,Hawb_hea,Nome_tp_Moeda,cta.dc_hea,vlr_org_hea,isnull(fatcod,Num_DCN_hea) Num_DCN_hea,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_exp_aer CTA with(nolock)
			Join House_exp_Aer HOU with(nolock) on hou.num_proc_hea=cta.num_proc_hea			
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hea
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hea=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hea=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hea)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEA=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEA=ax.dc 

		Where
			cd_Tp_Ativ='AGT' 
			and desp_DST_hea='N' 
			and convert(datetime,dt_ins_hea,103) between @DataInicial and @DataFinal
			and apelido like @Agente
	
		UNION ALL

		select 
			AX.id_Ax AX_ID, Dt_Ins_Him Data,MAWB_HIM,CTA.num_proc_Him,Apelido,Nome_tp_TX_ing,Hawb_HIM,Nome_tp_Moeda,cta.dc_HIM,vlr_org_HIM,isnull( cast(Num_DCN_HIM as char(17)),fatcod) Num_DCN_HIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_imp_MAR CTA with(nolock)
			Join House_Imp_MAR HOU with(nolock) on hou.num_proc_HIM=cta.num_proc_HIM
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_HIM
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_him=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_him=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_him)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIM=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIM=ax.dc 

		Where
			cd_Tp_Ativ='AGT' 
			and desp_org_HIM='N' 			
			and convert(datetime,dt_ins_HIM,103) between @DataInicial and @DataFinal
			and apelido like @Agente	

		UNION ALL

		select 
			AX.id_Ax AX_ID, Dt_Ins_Hem Data, MAWB_HEM,CTA.num_proc_hem,Apelido,Nome_tp_TX_ing,Hawb_HEM,Nome_tp_Moeda,cta.dc_HEM,vlr_org_HEM,cast(isnull(cast(Num_DCN_HEM as char(17)),fatcod) as varchar(17)) Num_DCN_HEM ,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_exp_MAR CTA with(nolock)
			Join House_exp_MAR HOU with(nolock) on hou.num_proc_HEM=cta.num_proc_HEM			
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_HEM
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hem=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hem=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hem)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEM=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEM=ax.dc 

		Where
			cd_Tp_Ativ='AGT' 
			and desp_DST_HEM='N' 
			and convert(datetime,dt_ins_HEM,103) between @DataInicial and @DataFinal
			and apelido like @Agente	

		Union All

		select 
			AX.id_Ax AX_ID,Dt_Ins_Hio Data,MAWB_HIO MAWB_MIA, CTA.Num_Proc_hio,Apelido,Nome_tp_TX_ing,Hawb_Hio,Nome_tp_Moeda,cta.dc_hio,vlr_org_hio,isnull(CAST(Num_DCN_HIO AS cHAR(17)),fatcod) Num_DCN_HIO,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_imp_out CTA with(nolock)
			Join House_Imp_OUT HOU with(nolock) on hou.num_proc_hio=cta.num_proc_hio
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hio
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hio=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hio=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hio)
			Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIO=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIO=ax.dc 

		Where
			cd_Tp_Ativ='AGT' 
			and desp_org_hio='N' 
			and convert(datetime,dt_ins_hio,103) between @DataInicial and @DataFinal
			and apelido like @Agente
		
		Union All
			
		select 
			AX.id_Ax AX_ID,Dt_Ins_Heo Data,MAWB_HEO MAWB_MIA, CTA.Num_Proc_heo,Apelido,Nome_tp_TX_ing,Hawb_Heo,Nome_tp_Moeda,cta.dc_heo,vlr_org_heo,isnull(CAST(Num_DCN_HEO AS cHAR(17)),fatcod) Num_DCN_HEO,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_hou_exp_out CTA with(nolock)
			Join House_EXP_OUT HOU with(nolock) on hou.num_proc_heo=cta.num_proc_heo
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_heo
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_heo=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_heo=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_heo)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEO=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEO=ax.dc 
		Where
			cd_Tp_Ativ='AGT' 
			and desp_org_heo='N' 
			and convert(datetime,dt_ins_heo,103) between @DataInicial and @DataFinal
			and apelido like @Agente
--MASTER
		UNION ALL
		select 
			AX.id_Ax AX_ID, Dt_Ins_mia Data, MAWB_MIA, CTA.Num_Proc_mia,Apelido,Nome_tp_TX_ing,Mawb_mia,Nome_tp_Moeda,cta.dc_mia,vlr_org_mia,isnull(CAST(CTA.Num_DCN_MIA AS cHAR(17)),fatcod) Num_DCN_HIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_mas_imp_aer CTA with(nolock)
			Join Master_Imp_Aer HOU with(nolock) on hou.num_proc_mia=cta.num_proc_mia			
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_mia
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_mia=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_mia=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_mia)
			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MIA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MIA=ax.dc 

		Where
			cd_Tp_Ativ='AGT'
			 and desp_org_mia='N'
			and convert(datetime,dt_ins_mia,103) between @DataInicial and @DataFinal
			and apelido like @Agente	

		UNION ALL
		select 
			AX.id_Ax AX_ID, Dt_Ins_MEA Data, MAWB_MEA,CTA.Num_Proc_MEA,Apelido,Nome_tp_TX_ing,Mawb_MEA,Nome_tp_Moeda,cta.dc_MEA,vlr_org_MEA,isnull(fatcod,CTA.Num_DCN_MEA) Num_DCN_MEA,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_MAS_exp_aer CTA with(nolock)
			Join MASTER_exp_Aer HOU with(nolock) on hou.num_proc_MEA=cta.num_proc_MEA
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MEA
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_MEA=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_MEA=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_MEA)
			Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MEA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MEA=ax.dc 

		Where
			cd_Tp_Ativ='AGT' 
			and desp_DST_MEA='N'
			and convert(datetime,dt_ins_MEA,103) between @DataInicial and @DataFinal
			and apelido like @Agente

		UNION ALL
		select 
			AX.id_Ax AX_ID, Dt_Ins_MIM Data,MAWB_MIM,CTA.num_proc_MIM,Apelido,Nome_tp_TX_ing,Mawb_MIM,Nome_tp_Moeda,cta.dc_MIM,vlr_org_MIM,isnull( cast(CTA.Num_DCN_MIM as char(17)),fatcod) Num_DCN_MIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_MAS_imp_MAR CTA with(nolock)
			Join MASTER_Imp_MAR HOU with(nolock) on hou.num_proc_MIM=cta.num_proc_MIM			
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MIM
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_MIM=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_MIM=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_MIM)
			Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MIM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MIM=ax.dc 

		Where
			cd_Tp_Ativ='AGT' 
			and desp_org_MIM='N' 
			and convert(datetime,dt_ins_MIM,103) between @DataInicial and @DataFinal
			and apelido like @Agente

		UNION ALL
		select 
			AX.id_Ax AX_ID,Dt_Ins_MEM Data, MAWB_MEM,CTA.num_proc_MEM,Apelido,Nome_tp_TX_ing,Mawb_MEM,Nome_tp_Moeda,cta.dc_MEM,vlr_org_MEM,cast(isnull(cast(CTA.Num_DCN_MEM as char(17)),fatcod) as varchar(17)) Num_DCN_MEM ,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
		From 
			cta_cte_MAS_exp_MAR CTA with(nolock)
			Join MASTER_exp_MAR HOU with(nolock) on hou.num_proc_MEM=cta.num_proc_MEM			
			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MEM
			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
			Left Join Item_Fat IT with(nolock) on CTA.num_proc_MEM=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_MEM=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_MEM)
			Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
				Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MEM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MEM  =ax.dc 

		Where
			cd_Tp_Ativ='AGT' 
			and desp_DST_MEM='N' 
			and convert(datetime,dt_ins_MEM,103) between @DataInicial and @DataFinal
			and apelido like @Agente

	END






----spStatement_Rel '2015/3/30','2015/04/30','2015/04/30','%','A' 
----alterado os caixas pra pegar da vwcxas
----alterado a paridade pra ser a divisão do Pgto pelo Ref
--ALTER    Procedure [dbo].[spStatement_Rel]
--	@DataInicial	VarChar(10),
--	@DataFinal	VarChar(10),
--	@DataPgto	VarChar(10),
--	@Agente		Varchar(30),
--	@Tipo		Char(1)

--AS
--If @Tipo='A'	
--	BEGIN
--		select 
--			AX.id_Ax AX_ID, Dt_Ins_Hia Data,MAWB_HIA MAWB_MIA, CTA.Num_Proc_hia,Apelido,Nome_tp_TX_ing,Hawb_Hia,Nome_tp_Moeda,cta.dc_hia,vlr_org_hia,isnull(CAST(Num_DCN_HIA AS cHAR(17)),fatcod) Num_DCN_HIA,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
--		From 
--			cta_cte_hou_imp_aer CTA with(nolock)
--			Join House_Imp_Aer HOU with(nolock) on hou.num_proc_hia=cta.num_proc_hia
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hia=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIA=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hia
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
--			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hia=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hia=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hia)
--			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIA=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIA=ax.dc 
--		Where
--			cd_Tp_Ativ='AGT' and desp_org_hia='N' and cxa.num_lcto is null
--			and convert(datetime,dt_ins_hia,103) between @DataInicial and @DataFinal
--			and apelido like @Agente	

--		UNION ALL

--		select 
--			AX.id_Ax AX_ID,Dt_Ins_Hea Data, MAWB_HEA,CTA.Num_Proc_Hea,Apelido,Nome_tp_TX_ing,Hawb_hea,Nome_tp_Moeda,cta.dc_hea,vlr_org_hea,isnull(fatcod,Num_DCN_hea) Num_DCN_hea,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
--		From 
--			cta_cte_hou_exp_aer CTA with(nolock)
--			Join House_exp_Aer HOU with(nolock) on hou.num_proc_hea=cta.num_proc_hea
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hea=CXA.Num_Proc_HIA AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_hea=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HIA,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hea
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Join Master_Exp_Aer mas on mas.num_proc_mea=hou.num_proc_mea
--			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hea=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hea=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hea)
--			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEA=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEA=ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_DST_hea='N' and cxa.num_lcto is null
--			and convert(datetime,dt_ins_hea,103) between @DataInicial and @DataFinal
--			and apelido like @Agente
	
--		UNION ALL

--		select 
--			AX.id_Ax AX_ID, Dt_Ins_Him Data,MAWB_HIM,CTA.num_proc_Him,Apelido,Nome_tp_TX_ing,Hawb_HIM,Nome_tp_Moeda,cta.dc_HIM,vlr_org_HIM,isnull( cast(Num_DCN_HIM as char(17)),fatcod) Num_DCN_HIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
--		From 
--			cta_cte_hou_imp_MAR CTA with(nolock)
--			Join House_Imp_MAR HOU with(nolock) on hou.num_proc_HIM=cta.num_proc_HIM
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_HIM=CXA.num_proc_HIa AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIM=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HIA,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_HIM
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Join Master_Imp_Mar mas on mas.num_proc_mim=hou.num_proc_mim
--			Left Join Item_Fat IT with(nolock) on CTA.num_proc_him=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_him=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_him)
--			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIM=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIM=ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_org_HIM='N' and cxa.num_lcto is null
--			and convert(datetime,dt_ins_HIM,103) between @DataInicial and @DataFinal
--			and apelido like @Agente	

--		UNION ALL

--		select 
--			AX.id_Ax AX_ID, Dt_Ins_Hem Data, MAWB_HEM,CTA.num_proc_hem,Apelido,Nome_tp_TX_ing,Hawb_HEM,Nome_tp_Moeda,cta.dc_HEM,vlr_org_HEM,cast(isnull(cast(Num_DCN_HEM as char(17)),fatcod) as varchar(17)) Num_DCN_HEM ,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
--		From 
--			cta_cte_hou_exp_MAR CTA with(nolock)
--			Join House_exp_MAR HOU with(nolock) on hou.num_proc_HEM=cta.num_proc_HEM
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_HEM=CXA.num_proc_Hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HEM=CXA.DC_Hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HIA,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_HEM
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Join Master_Exp_Mar mas on mas.num_proc_mem=hou.num_proc_mem
--			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hem=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hem=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hem)
--			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEM=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEM=ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_DST_HEM='N' and cxa.num_lcto is null
--			and convert(datetime,dt_ins_HEM,103) between @DataInicial and @DataFinal
--			and apelido like @Agente	

--		Union All

--		select 
--			AX.id_Ax AX_ID,Dt_Ins_Hio Data,MAWB_HIO MAWB_MIA, CTA.Num_Proc_hio,Apelido,Nome_tp_TX_ing,Hawb_Hio,Nome_tp_Moeda,cta.dc_hio,vlr_org_hio,isnull(CAST(Num_DCN_HIO AS cHAR(17)),fatcod) Num_DCN_HIO,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
--		From 
--			cta_cte_hou_imp_out CTA with(nolock)
--			Join House_Imp_OUT HOU with(nolock) on hou.num_proc_hio=cta.num_proc_hio
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hio=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIO=CXA.DC_HIa and num_lcto <> 'PROVISÓRIO' and convert(datetime,Dt_Pgto_Rcto_HIA,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hio
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
--			Left Join Item_Fat IT with(nolock) on CTA.num_proc_hio=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hio=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hio)
--			Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIO=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIO=ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_org_hio='N' and cxa.num_lcto is null
--			and convert(datetime,dt_ins_hio,103) between @DataInicial and @DataFinal
--			and apelido like @Agente
		
--		Union All
			
--		select 
--			AX.id_Ax AX_ID,Dt_Ins_Heo Data,MAWB_HEO MAWB_MIA, CTA.Num_Proc_heo,Apelido,Nome_tp_TX_ing,Hawb_Heo,Nome_tp_Moeda,cta.dc_heo,vlr_org_heo,isnull(CAST(Num_DCN_HEO AS cHAR(17)),fatcod) Num_DCN_HEO,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
--		From 
--			cta_cte_hou_exp_out CTA with(nolock)
--			Join House_EXP_OUT HOU with(nolock) on hou.num_proc_heo=cta.num_proc_heo
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_heo=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HeO=CXA.DC_Hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_heo
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
--			Left Join Item_Fat IT with(nolock) on CTA.num_proc_heo=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_heo=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_heo)
--			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEO=ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEO=ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_org_heo='N' and cxa.num_lcto is null
--			and convert(datetime,dt_ins_heo,103) between @DataInicial and @DataFinal
--			and apelido like @Agente
----MASTER
--		UNION ALL
--		select 
--			AX.id_Ax AX_ID, Dt_Ins_mia Data, MAWB_MIA, CTA.Num_Proc_mia,Apelido,Nome_tp_TX_ing,Mawb_mia,Nome_tp_Moeda,cta.dc_mia,vlr_org_mia,isnull(CAST(CTA.Num_DCN_MIA AS cHAR(17)),fatcod) Num_DCN_HIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
--		From 
--			cta_cte_mas_imp_aer CTA with(nolock)
--			Join Master_Imp_Aer HOU with(nolock) on hou.num_proc_mia=cta.num_proc_mia
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_mia=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIA=CXA.DC_hIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_mia
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Left Join Item_Fat IT with(nolock) on CTA.num_proc_mia=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_mia=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_mia)
--			Left Join Paridade PAr with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MIA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MIA=ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_org_mia='N' and cxa.num_lcto is null
--			and convert(datetime,dt_ins_mia,103) between @DataInicial and @DataFinal
--			and apelido like @Agente	

--		UNION ALL
--		select 
--			AX.id_Ax AX_ID, Dt_Ins_MEA Data, MAWB_MEA,CTA.Num_Proc_MEA,Apelido,Nome_tp_TX_ing,Mawb_MEA,Nome_tp_Moeda,cta.dc_MEA,vlr_org_MEA,isnull(fatcod,CTA.Num_DCN_MEA) Num_DCN_MEA,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
--		From 
--			cta_cte_MAS_exp_aer CTA with(nolock)
--			Join MASTER_exp_Aer HOU with(nolock) on hou.num_proc_MEA=cta.num_proc_MEA
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MEA=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEA=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MEA
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Left Join Item_Fat IT with(nolock) on CTA.num_proc_MEA=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_MEA=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_MEA)
--			Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MEA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MEA=ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_DST_MEA='N' and cxa.num_lcto is null
--			and convert(datetime,dt_ins_MEA,103) between @DataInicial and @DataFinal
--			and apelido like @Agente

--		UNION ALL
--		select 
--			AX.id_Ax AX_ID, Dt_Ins_MIM Data,MAWB_MIM,CTA.num_proc_MIM,Apelido,Nome_tp_TX_ing,Mawb_MIM,Nome_tp_Moeda,cta.dc_MIM,vlr_org_MIM,isnull( cast(CTA.Num_DCN_MIM as char(17)),fatcod) Num_DCN_MIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
--		From 
--			cta_cte_MAS_imp_MAR CTA with(nolock)
--			Join MASTER_Imp_MAR HOU with(nolock) on hou.num_proc_MIM=cta.num_proc_MIM
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MIM=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIM=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MIM
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Left Join Item_Fat IT with(nolock) on CTA.num_proc_MIM=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_MIM=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_MIM)
--			Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MIM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MIM=ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_org_MIM='N' and cxa.num_lcto is null
--			and convert(datetime,dt_ins_MIM,103) between @DataInicial and @DataFinal
--			and apelido like @Agente

--		UNION ALL
--		select 
--			AX.id_Ax AX_ID,Dt_Ins_MEM Data, MAWB_MEM,CTA.num_proc_MEM,Apelido,Nome_tp_TX_ing,Mawb_MEM,Nome_tp_Moeda,cta.dc_MEM,vlr_org_MEM,cast(isnull(cast(CTA.Num_DCN_MEM as char(17)),fatcod) as varchar(17)) Num_DCN_MEM ,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
--		From 
--			cta_cte_MAS_exp_MAR CTA with(nolock)
--			Join MASTER_exp_MAR HOU with(nolock) on hou.num_proc_MEM=cta.num_proc_MEM
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MEM=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEM=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MEM
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Left Join Item_Fat IT with(nolock) on CTA.num_proc_MEM=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_MEM=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_MEM)
--			Left Join Paridade PAR with(nolock) on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
--				Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MEM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MEM  =ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_DST_MEM='N' and cxa.num_lcto is null
--			and convert(datetime,dt_ins_MEM,103) between @DataInicial and @DataFinal
--			and apelido like @Agente

--	END
		
--ELSE
--	BEGIN
--		select 
--			AX.id_Ax AX_ID,Dt_Ins_Hia Data,MAWB_HIA MAWB_MIA,CTA.Num_Proc_hia,Apelido,Nome_tp_TX_ing,Hawb_Hia,Nome_tp_Moeda,cta.dc_hia,vlr_org_hia,Num_DCN_HIA,cta.cd_tp_moeda,
--			--CXA.Par_Moeda_HIA Paridade
--			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
--		From 
--			cta_cte_hou_imp_aer CTA with(nolock)
--			Join House_Imp_Aer HOU with(nolock) on hou.num_proc_hia=cta.num_proc_hia
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hia=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIA=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hia
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIA  =ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_org_hia='N' and cxa.num_lcto is NOT null
--			and convert(datetime,dt_ins_hia,103) between @DataInicial and @DataFinal
--			and apelido like @Agente	

--		UNION ALL
--		select 
--			AX.id_Ax AX_ID,Dt_Ins_Hea Data, MAWB_HEA,CTA.Num_Proc_Hea,Apelido,Nome_tp_TX_ing,Hawb_hea,Nome_tp_Moeda,cta.dc_hea,vlr_org_hea,Num_DCN_hea,cta.cd_Tp_moeda,
--			-- cxa.Par_Moeda_hea  Paridade
--			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
--		From 
--			cta_cte_hou_exp_aer CTA with(nolock)
--			Join House_exp_Aer HOU with(nolock) on hou.num_proc_hea=cta.num_proc_hea
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hea=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_hea=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hea
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Join Master_Exp_Aer mas on mas.num_proc_mea=hou.num_proc_mea
--			Left Join vwAXDocs AX on CTA.Num_Proc_HEA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEA  =ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_DST_hea='N' and cxa.num_lcto is NOT null
--			and convert(datetime,dt_ins_hea,103) between @DataInicial and @DataFinal
--			and apelido like @Agente

--		UNION ALL

--		select 
--			AX.id_Ax AX_ID,Dt_Ins_Him Data,MAWB_HIM,CTA.num_proc_Him,Apelido,Nome_tp_TX_ing,Hawb_HIM,Nome_tp_Moeda,cta.dc_HIM,vlr_org_HIM,Num_DCN_HIM,cta.cd_tp_moeda,
--			--CXA.Par_Moeda_him Paridade
--			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
--		From 
--			cta_cte_hou_imp_MAR CTA with(nolock)
--			Join House_Imp_MAR HOU with(nolock) on hou.num_proc_HIM=cta.num_proc_HIM
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_HIM=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIM=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_HIM
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HIM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIM  =ax.dc 

----			Join Master_Imp_Mar mas on mas.num_proc_mim=hou.num_proc_mim
--		Where
--			cd_Tp_Ativ='AGT' and desp_org_HIM='N' and cxa.num_lcto is NOT null
--			and convert(datetime,dt_ins_HIM,103) between @DataInicial and @DataFinal
--			and apelido like @Agente	

--		UNION ALL

--		select 
--			AX.id_Ax AX_ID,Dt_Ins_Hem Data, MaWB_HEM,CTA.num_proc_hem,Apelido,Nome_tp_TX_ing,Hawb_HEM,Nome_tp_Moeda,cta.dc_HEM,vlr_org_HEM,Num_DCN_HEM ,cta.cd_Tp_moeda,
--			--CXA.Par_Moeda_HEM Paridade
--			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
--		From 
--			cta_cte_hou_exp_MAR CTA with(nolock)
--			Join House_exp_MAR HOU with(nolock) on hou.num_proc_HEM=cta.num_proc_HEM
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_HEM=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HEM=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_HEM
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Join Master_Exp_Mar mas on mas.num_proc_mem=hou.num_proc_mem
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEM  =ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_DST_HEM='N' and cxa.num_lcto is NOT null
--			and convert(datetime,dt_ins_HEM,103) between @DataInicial and @DataFinal
--			and apelido like @Agente

--		Union All

--	select 
--			AX.id_Ax AX_ID,Dt_Ins_Hio Data,MAWB_HIO MAWB_MIA,CTA.Num_Proc_hio,Apelido,Nome_tp_TX_ing,Hawb_Hio,Nome_tp_Moeda,cta.dc_hio,vlr_org_hio,Num_DCN_HIO,cta.cd_tp_moeda,
--			--CXA.Par_Moeda_HIO Paridade
--			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
--		From 
--			cta_cte_hou_imp_out CTA with(nolock)
--			Join House_Imp_OUT HOU with(nolock) on hou.num_proc_hio=cta.num_proc_hio
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_hio=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIO=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_hio
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
--			Left Join vwAXDocs AX   with(nolock) on CTA.Num_Proc_HIO =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HIO  =ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_org_hio='N' and cxa.num_lcto is NOT null
--			and convert(datetime,dt_ins_hio,103) between @DataInicial and @DataFinal
--			and apelido like @Agente

--		Union All
		
--	select 
--			AX.id_Ax AX_ID,Dt_Ins_Heo Data,MAWB_HEO MAWB_MIA,CTA.Num_Proc_heo,Apelido,Nome_tp_TX_ing,Hawb_Heo,Nome_tp_Moeda,cta.dc_heo,vlr_org_heo,Num_DCN_HEO,cta.cd_tp_moeda,
--			--CXA.Par_Moeda_HEO Paridade
--			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
--		From 
--			cta_cte_hou_exp_out CTA with(nolock)
--			Join House_Exp_OUT HOU with(nolock) on hou.num_proc_heo=cta.num_proc_heo
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_heo=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HEO=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_heo
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_HEO =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_HEO  =ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_org_heo='N' and cxa.num_lcto is NOT null
--			and convert(datetime,dt_ins_heo,103) between @DataInicial and @DataFinal
--			and apelido like @Agente	

----MASTER
--		UNION ALL
--		select 
--			AX.id_Ax AX_ID,Dt_Ins_MIA Data,MAWB_MIA MAWB_MIA,CTA.Num_Proc_MIA,Apelido,Nome_tp_TX_ing,Mawb_MIA,Nome_tp_Moeda,cta.dc_MIA,vlr_org_MIA,CTA.Num_DCN_MIA,cta.cd_tp_moeda,
--			--CXA.Par_Moeda_MIA Paridade
--			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
--		From 
--			cta_cte_MAS_imp_aer CTA with(nolock)
--			Join MASTER_Imp_Aer HOU with(nolock) on hou.num_proc_MIA=cta.num_proc_MIA
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MIA=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIA=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MIA
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MIA  =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MIA  =ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_org_MIA='N' and cxa.num_lcto is NOT null
--			and convert(datetime,dt_ins_MIA,103) between @DataInicial and @DataFinal
--			and apelido like @Agente	

--		UNION ALL
--		select 
--			AX.id_Ax AX_ID,Dt_Ins_MEA Data, MAWB_MEA,CTA.Num_Proc_MEA,Apelido,Nome_tp_TX_ing,Mawb_MEA,Nome_tp_Moeda,cta.dc_MEA,vlr_org_MEA,CTA.Num_DCN_MEA,cta.cd_Tp_moeda,
--			--cxa.Par_Moeda_MEA  Paridade
--			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
--		From 
--			cta_cte_MAS_exp_aer CTA with(nolock)
--			Join MASTER_EXP_Aer HOU with(nolock) on hou.num_proc_MEA=cta.num_proc_MEA
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MEA=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEA=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MEA
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MEA =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MEA  =ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_DST_MEA='N' and cxa.num_lcto is NOT null
--			and convert(datetime,dt_ins_MEA,103) between @DataInicial and @DataFinal
--			and apelido like @Agente

--		UNION ALL
--		select 
--			AX.id_Ax AX_ID,Dt_Ins_MIM Data,MAWB_MIM,CTA.num_proc_MIM,Apelido,Nome_tp_TX_ing,Mawb_MIM,Nome_tp_Moeda,cta.dc_MIM,vlr_org_MIM,CTA.Num_DCN_MIM,cta.cd_tp_moeda,
--			--CXA.Par_Moeda_MIM Paridade
--			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
--		From 
--			cta_cte_MAS_imp_MAR CTA with(nolock)
--			Join MASTER_Imp_MAR HOU with(nolock) on hou.num_proc_MIM=cta.num_proc_MIM
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MIM=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIM=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MIM
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MIM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MIM  =ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_org_MIM='N' and cxa.num_lcto is NOT null
--			and convert(datetime,dt_ins_MIM,103) between @DataInicial and @DataFinal
--			and apelido like @Agente

--		UNION ALL
--		select 
--			AX.id_Ax AX_ID,Dt_Ins_MEM Data, MaWB_MEM,CTA.num_proc_MEM,Apelido,Nome_tp_TX_ing,Mawb_MEM,Nome_tp_Moeda,cta.dc_MEM,vlr_org_MEM,CTA.Num_DCN_MEM ,cta.cd_Tp_moeda,
--			--CXA.Par_Moeda_MEM Paridade
--			cxa.Vlr_Pgto_Rcto_HIA / cxa.Vlr_Ref_HIA Paridade
--		From 
--			cta_cte_MAS_exp_MAR CTA with(nolock)
--			Join MASTER_exp_MAR HOU with(nolock) on hou.num_proc_MEM=cta.num_proc_MEM
--			Left Join vwcxas CXA with(nolock) on CTA.num_proc_MEM=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEM=CXA.DC_hia and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
--			Join Pessoa PP with(nolock) on PP.cd_pes=cd_cred_dev_MEM
--			Join Tipo_Taxa TT with(nolock) on TT.cd_tp_tx=cta.CD_tP_tX
--			Join Tipo_Moeda TM with(nolock) on TM.cd_tp_moeda=cta.cd_tp_moeda
--			Left Join vwAXDocs AX  with(nolock) on CTA.Num_Proc_MEM =ax.num_proc and cta.Cd_Tp_Tx=AX.cd_tp_tx_Atl and CTA.DC_MEM  =ax.dc 

--		Where
--			cd_Tp_Ativ='AGT' and desp_DST_MEM='N' and cxa.num_lcto is NOT null
--			and convert(datetime,dt_ins_MEM,103) between @DataInicial and @DataFinal
--			and apelido like @Agente

--	END
	

----ALTER      Procedure [dbo].[spStatement_Rel]
----	@DataInicial	VarChar(10),
----	@DataFinal	VarChar(10),
----	@DataPgto	VarChar(10),
----	@Agente		Varchar(30),
----	@Tipo		Char(1)

----AS
----If @Tipo='A'	
----	BEGIN
----		select 
----			Dt_Ins_Hia Data,MAWB_HIA MAWB_MIA, CTA.Num_Proc_hia,Apelido,Nome_tp_TX_ing,Hawb_Hia,Nome_tp_Moeda,cta.dc_hia,vlr_org_hia,isnull(CAST(Num_DCN_HIA AS cHAR(17)),fatcod) Num_DCN_HIA,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
----		From 
----			cta_cte_hou_imp_aer CTA
----			Join House_Imp_Aer HOU on hou.num_proc_hia=cta.num_proc_hia
----			Left Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIA=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
------			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
----			Left Join Item_Fat IT on CTA.num_proc_hia=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hia=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hia)
----			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
----		Where
----			cd_Tp_Ativ='AGT' and desp_org_hia='N' and cxa.num_lcto is null
----			and convert(datetime,dt_ins_hia,103) between @DataInicial and @DataFinal
----			and apelido like @Agente	

----		UNION ALL

----		select 
----			Dt_Ins_Hea Data, MAWB_HEA,CTA.Num_Proc_Hea,Apelido,Nome_tp_TX_ing,Hawb_hea,Nome_tp_Moeda,cta.dc_hea,vlr_org_hea,isnull(fatcod,Num_DCN_hea) Num_DCN_hea,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
----		From 
----			cta_cte_hou_exp_aer CTA
----			Join House_exp_Aer HOU on hou.num_proc_hea=cta.num_proc_hea
----			Left Join Caixa_hou_exp_aer CXA on CTA.num_proc_hea=CXA.num_proc_hea AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_hea=CXA.DC_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hea,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_hea
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
------			Join Master_Exp_Aer mas on mas.num_proc_mea=hou.num_proc_mea
----			Left Join Item_Fat IT on CTA.num_proc_hea=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hea=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hea)
----			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
----		Where
----			cd_Tp_Ativ='AGT' and desp_DST_hea='N' and cxa.num_lcto is null
----			and convert(datetime,dt_ins_hea,103) between @DataInicial and @DataFinal
----			and apelido like @Agente
	
----		UNION ALL

----		select 
----			Dt_Ins_Him Data,MAWB_HIM,CTA.num_proc_Him,Apelido,Nome_tp_TX_ing,Hawb_HIM,Nome_tp_Moeda,cta.dc_HIM,vlr_org_HIM,isnull( cast(Num_DCN_HIM as char(17)),fatcod) Num_DCN_HIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
----		From 
----			cta_cte_hou_imp_MAR CTA
----			Join House_Imp_MAR HOU on hou.num_proc_HIM=cta.num_proc_HIM
----			Left Join Caixa_hou_imp_MAR CXA on CTA.num_proc_HIM=CXA.num_proc_HIM AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIM=CXA.DC_HIM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_HIM,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_HIM
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
------			Join Master_Imp_Mar mas on mas.num_proc_mim=hou.num_proc_mim
----			Left Join Item_Fat IT on CTA.num_proc_him=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_him=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_him)
----			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
----		Where
----			cd_Tp_Ativ='AGT' and desp_org_HIM='N' and cxa.num_lcto is null
----			and convert(datetime,dt_ins_HIM,103) between @DataInicial and @DataFinal
----			and apelido like @Agente	

----		UNION ALL

----		select 
----			Dt_Ins_Hem Data, MAWB_HEM,CTA.num_proc_hem,Apelido,Nome_tp_TX_ing,Hawb_HEM,Nome_tp_Moeda,cta.dc_HEM,vlr_org_HEM,cast(isnull(cast(Num_DCN_HEM as char(17)),fatcod) as varchar(17)) Num_DCN_HEM ,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
----		From 
----			cta_cte_hou_exp_MAR CTA
----			Join House_exp_MAR HOU on hou.num_proc_HEM=cta.num_proc_HEM
----			Left Join Caixa_hou_exp_MAR CXA on CTA.num_proc_HEM=CXA.num_proc_HEM AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HEM=CXA.DC_HEM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_HEM,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_HEM
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
------			Join Master_Exp_Mar mas on mas.num_proc_mem=hou.num_proc_mem
----			Left Join Item_Fat IT on CTA.num_proc_hem=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hem=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hem)
----			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
----		Where
----			cd_Tp_Ativ='AGT' and desp_DST_HEM='N' and cxa.num_lcto is null
----			and convert(datetime,dt_ins_HEM,103) between @DataInicial and @DataFinal
----			and apelido like @Agente	

----		Union All

----		select 
----			Dt_Ins_Hio Data,MAWB_HIO MAWB_MIA, CTA.Num_Proc_hio,Apelido,Nome_tp_TX_ing,Hawb_Hio,Nome_tp_Moeda,cta.dc_hio,vlr_org_hio,isnull(CAST(Num_DCN_HIO AS cHAR(17)),fatcod) Num_DCN_HIO,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
----		From 
----			cta_cte_hou_imp_out CTA
----			Join House_Imp_OUT HOU on hou.num_proc_hio=cta.num_proc_hio
----			Left Join Caixa_hou_imp_out CXA on CTA.num_proc_hio=CXA.num_proc_hio AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIO=CXA.DC_HIO and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hio,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_hio
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
------			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
----			Left Join Item_Fat IT on CTA.num_proc_hio=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_hio=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_hio)
----			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
----		Where
----			cd_Tp_Ativ='AGT' and desp_org_hio='N' and cxa.num_lcto is null
----			and convert(datetime,dt_ins_hio,103) between @DataInicial and @DataFinal
----			and apelido like @Agente
		
----		Union All
			
----		select 
----			Dt_Ins_Heo Data,MAWB_HEO MAWB_MIA, CTA.Num_Proc_heo,Apelido,Nome_tp_TX_ing,Hawb_Heo,Nome_tp_Moeda,cta.dc_heo,vlr_org_heo,isnull(CAST(Num_DCN_HEO AS cHAR(17)),fatcod) Num_DCN_HEO,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
----		From 
----			cta_cte_hou_exp_out CTA
----			Join House_EXP_OUT HOU on hou.num_proc_heo=cta.num_proc_heo
----			Left Join Caixa_hou_exp_out CXA on CTA.num_proc_heo=CXA.num_proc_heo AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HeO=CXA.DC_HEO and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_heo,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_heo
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
------			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
----			Left Join Item_Fat IT on CTA.num_proc_heo=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_heo=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_heo)
----			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
----		Where
----			cd_Tp_Ativ='AGT' and desp_org_heo='N' and cxa.num_lcto is null
----			and convert(datetime,dt_ins_heo,103) between @DataInicial and @DataFinal
----			and apelido like @Agente
------MASTER
----		UNION ALL
----		select 
----			Dt_Ins_mia Data, MAWB_MIA, CTA.Num_Proc_mia,Apelido,Nome_tp_TX_ing,Mawb_mia,Nome_tp_Moeda,cta.dc_mia,vlr_org_mia,isnull(CAST(CTA.Num_DCN_MIA AS cHAR(17)),fatcod) Num_DCN_HIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
----		From 
----			cta_cte_mas_imp_aer CTA
----			Join Master_Imp_Aer HOU on hou.num_proc_mia=cta.num_proc_mia
----			Left Join Caixa_mas_imp_aer CXA on CTA.num_proc_mia=CXA.num_proc_mia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIA=CXA.DC_MIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_mia,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_mia
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Left Join Item_Fat IT on CTA.num_proc_mia=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_mia=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_mia)
----			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
----		Where
----			cd_Tp_Ativ='AGT' and desp_org_mia='N' and cxa.num_lcto is null
----			and convert(datetime,dt_ins_mia,103) between @DataInicial and @DataFinal
----			and apelido like @Agente	

----		UNION ALL
----		select 
----			Dt_Ins_MEA Data, MAWB_MEA,CTA.Num_Proc_MEA,Apelido,Nome_tp_TX_ing,Mawb_MEA,Nome_tp_Moeda,cta.dc_MEA,vlr_org_MEA,isnull(fatcod,CTA.Num_DCN_MEA) Num_DCN_MEA,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
----		From 
----			cta_cte_MAS_exp_aer CTA
----			Join MASTER_exp_Aer HOU on hou.num_proc_MEA=cta.num_proc_MEA
----			Left Join Caixa_MAS_exp_aer CXA on CTA.num_proc_MEA=CXA.num_proc_MEA AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEA=CXA.DC_MEA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_MEA,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_MEA
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Left Join Item_Fat IT on CTA.num_proc_MEA=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_MEA=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_MEA)
----			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
----		Where
----			cd_Tp_Ativ='AGT' and desp_DST_MEA='N' and cxa.num_lcto is null
----			and convert(datetime,dt_ins_MEA,103) between @DataInicial and @DataFinal
----			and apelido like @Agente

----		UNION ALL
----		select 
----			Dt_Ins_MIM Data,MAWB_MIM,CTA.num_proc_MIM,Apelido,Nome_tp_TX_ing,Mawb_MIM,Nome_tp_Moeda,cta.dc_MIM,vlr_org_MIM,isnull( cast(CTA.Num_DCN_MIM as char(17)),fatcod) Num_DCN_MIM,cta.cd_tp_moeda,PAR.Par_Moeda Paridade
----		From 
----			cta_cte_MAS_imp_MAR CTA
----			Join MASTER_Imp_MAR HOU on hou.num_proc_MIM=cta.num_proc_MIM
----			Left Join Caixa_MAS_imp_MAR CXA on CTA.num_proc_MIM=CXA.num_proc_MIM AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIM=CXA.DC_MIM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_MIM,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_MIM
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Left Join Item_Fat IT on CTA.num_proc_MIM=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_MIM=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_MIM)
----			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
----		Where
----			cd_Tp_Ativ='AGT' and desp_org_MIM='N' and cxa.num_lcto is null
----			and convert(datetime,dt_ins_MIM,103) between @DataInicial and @DataFinal
----			and apelido like @Agente

----		UNION ALL
----		select 
----			Dt_Ins_MEM Data, MAWB_MEM,CTA.num_proc_MEM,Apelido,Nome_tp_TX_ing,Mawb_MEM,Nome_tp_Moeda,cta.dc_MEM,vlr_org_MEM,cast(isnull(cast(CTA.Num_DCN_MEM as char(17)),fatcod) as varchar(17)) Num_DCN_MEM ,cta.cd_Tp_moeda,PAR.Par_Moeda Paridade
----		From 
----			cta_cte_MAS_exp_MAR CTA
----			Join MASTER_exp_MAR HOU on hou.num_proc_MEM=cta.num_proc_MEM
----			Left Join Caixa_MAS_exp_MAR CXA on CTA.num_proc_MEM=CXA.num_proc_MEM AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEM=CXA.DC_MEM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_MEM,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_MEM
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
----			Left Join Item_Fat IT on CTA.num_proc_MEM=IT.num_proc and cta.cd_tp_Tx=it.cd_tp_tx and cta.dc_MEM=it.dc and fatcod in (select fatcod from fatura where fatstatus = 1 and left(fatcod,16)=cta.num_proc_MEM)
----			Left Join Paridade PAr on CTA.cd_tp_moeda=par.cd_tp_moeda and par.cd_tp_par='OFC' and convert(datetime,Dt_par,105)=convert(varchar(10),getdatE(),110)
----		Where
----			cd_Tp_Ativ='AGT' and desp_DST_MEM='N' and cxa.num_lcto is null
----			and convert(datetime,dt_ins_MEM,103) between @DataInicial and @DataFinal
----			and apelido like @Agente

----	END
		
----ELSE
----	BEGIN
----		select 
----			Dt_Ins_Hia Data,MAWB_HIA MAWB_MIA,CTA.Num_Proc_hia,Apelido,Nome_tp_TX_ing,Hawb_Hia,Nome_tp_Moeda,cta.dc_hia,vlr_org_hia,Num_DCN_HIA,cta.cd_tp_moeda,CXA.Par_Moeda_HIA Paridade
----		From 
----			cta_cte_hou_imp_aer CTA
----			Join House_Imp_Aer HOU on hou.num_proc_hia=cta.num_proc_hia
----			Left Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=CXA.num_proc_hia AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIA=CXA.DC_HIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hia,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_hia
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
------			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
----		Where
----			cd_Tp_Ativ='AGT' and desp_org_hia='N' and cxa.num_lcto is NOT null
----			and convert(datetime,dt_ins_hia,103) between @DataInicial and @DataFinal
----			and apelido like @Agente	

----		UNION ALL
----		select 
----			Dt_Ins_Hea Data, MAWB_HEA,CTA.Num_Proc_Hea,Apelido,Nome_tp_TX_ing,Hawb_hea,Nome_tp_Moeda,cta.dc_hea,vlr_org_hea,Num_DCN_hea,cta.cd_Tp_moeda,cxa.Par_Moeda_hea  Paridade
----		From 
----			cta_cte_hou_exp_aer CTA
----			Join House_exp_Aer HOU on hou.num_proc_hea=cta.num_proc_hea
----			Left Join Caixa_hou_exp_aer CXA on CTA.num_proc_hea=CXA.num_proc_hea AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_hea=CXA.DC_hea and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hea,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_hea
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
------			Join Master_Exp_Aer mas on mas.num_proc_mea=hou.num_proc_mea

----		Where
----			cd_Tp_Ativ='AGT' and desp_DST_hea='N' and cxa.num_lcto is NOT null
----			and convert(datetime,dt_ins_hea,103) between @DataInicial and @DataFinal
----			and apelido like @Agente

----		UNION ALL

----		select 
----			Dt_Ins_Him Data,MAWB_HIM,CTA.num_proc_Him,Apelido,Nome_tp_TX_ing,Hawb_HIM,Nome_tp_Moeda,cta.dc_HIM,vlr_org_HIM,Num_DCN_HIM,cta.cd_tp_moeda,CXA.Par_Moeda_him Paridade
----		From 
----			cta_cte_hou_imp_MAR CTA
----			Join House_Imp_MAR HOU on hou.num_proc_HIM=cta.num_proc_HIM
----			Left Join Caixa_hou_imp_MAR CXA on CTA.num_proc_HIM=CXA.num_proc_HIM AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIM=CXA.DC_HIM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_HIM,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_HIM
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
------			Join Master_Imp_Mar mas on mas.num_proc_mim=hou.num_proc_mim
----		Where
----			cd_Tp_Ativ='AGT' and desp_org_HIM='N' and cxa.num_lcto is NOT null
----			and convert(datetime,dt_ins_HIM,103) between @DataInicial and @DataFinal
----			and apelido like @Agente	

----		UNION ALL

----		select 
----			Dt_Ins_Hem Data, MaWB_HEM,CTA.num_proc_hem,Apelido,Nome_tp_TX_ing,Hawb_HEM,Nome_tp_Moeda,cta.dc_HEM,vlr_org_HEM,Num_DCN_HEM ,cta.cd_Tp_moeda,CXA.Par_Moeda_HEM Paridade
----		From 
----			cta_cte_hou_exp_MAR CTA
----			Join House_exp_MAR HOU on hou.num_proc_HEM=cta.num_proc_HEM
----			Left Join Caixa_hou_exp_MAR CXA on CTA.num_proc_HEM=CXA.num_proc_HEM AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HEM=CXA.DC_HEM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_HEM,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_HEM
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
------			Join Master_Exp_Mar mas on mas.num_proc_mem=hou.num_proc_mem
----		Where
----			cd_Tp_Ativ='AGT' and desp_DST_HEM='N' and cxa.num_lcto is NOT null
----			and convert(datetime,dt_ins_HEM,103) between @DataInicial and @DataFinal
----			and apelido like @Agente

----		Union All

----	select 
----			Dt_Ins_Hio Data,MAWB_HIO MAWB_MIA,CTA.Num_Proc_hio,Apelido,Nome_tp_TX_ing,Hawb_Hio,Nome_tp_Moeda,cta.dc_hio,vlr_org_hio,Num_DCN_HIO,cta.cd_tp_moeda,CXA.Par_Moeda_HIO Paridade
----		From 
----			cta_cte_hou_imp_out CTA
----			Join House_Imp_OUT HOU on hou.num_proc_hio=cta.num_proc_hio
----			Left Join Caixa_hou_imp_out CXA on CTA.num_proc_hio=CXA.num_proc_hio AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HIO=CXA.DC_HIO and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_hio,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_hio
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
------			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
----		Where
----			cd_Tp_Ativ='AGT' and desp_org_hio='N' and cxa.num_lcto is NOT null
----			and convert(datetime,dt_ins_hio,103) between @DataInicial and @DataFinal
----			and apelido like @Agente

----		Union All
		
----	select 
----			Dt_Ins_Heo Data,MAWB_HEO MAWB_MIA,CTA.Num_Proc_heo,Apelido,Nome_tp_TX_ing,Hawb_Heo,Nome_tp_Moeda,cta.dc_heo,vlr_org_heo,Num_DCN_HEO,cta.cd_tp_moeda,CXA.Par_Moeda_HEO Paridade
----		From 
----			cta_cte_hou_exp_out CTA
----			Join House_Exp_OUT HOU on hou.num_proc_heo=cta.num_proc_heo
----			Left Join Caixa_hou_exp_out CXA on CTA.num_proc_heo=CXA.num_proc_heo AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_HEO=CXA.DC_HEO and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_heo,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_heo
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
------			Join Master_Imp_Aer MAS on mas.num_proc_mia=hou.num_proc_mia
----		Where
----			cd_Tp_Ativ='AGT' and desp_org_heo='N' and cxa.num_lcto is NOT null
----			and convert(datetime,dt_ins_heo,103) between @DataInicial and @DataFinal
----			and apelido like @Agente	

------MASTER
----		UNION ALL
----		select 
----			Dt_Ins_MIA Data,MAWB_MIA MAWB_MIA,CTA.Num_Proc_MIA,Apelido,Nome_tp_TX_ing,Mawb_MIA,Nome_tp_Moeda,cta.dc_MIA,vlr_org_MIA,CTA.Num_DCN_MIA,cta.cd_tp_moeda,CXA.Par_Moeda_MIA Paridade
----		From 
----			cta_cte_MAS_imp_aer CTA
----			Join MASTER_Imp_Aer HOU on hou.num_proc_MIA=cta.num_proc_MIA
----			Left Join Caixa_MAS_imp_aer CXA on CTA.num_proc_MIA=CXA.num_proc_MIA AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIA=CXA.DC_MIA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_MIA,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_MIA
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
----		Where
----			cd_Tp_Ativ='AGT' and desp_org_MIA='N' and cxa.num_lcto is NOT null
----			and convert(datetime,dt_ins_MIA,103) between @DataInicial and @DataFinal
----			and apelido like @Agente	

----		UNION ALL
----		select 
----			Dt_Ins_MEA Data, MAWB_MEA,CTA.Num_Proc_MEA,Apelido,Nome_tp_TX_ing,Mawb_MEA,Nome_tp_Moeda,cta.dc_MEA,vlr_org_MEA,CTA.Num_DCN_MEA,cta.cd_Tp_moeda,cxa.Par_Moeda_MEA  Paridade
----		From 
----			cta_cte_MAS_exp_aer CTA
----			Join MASTER_EXP_Aer HOU on hou.num_proc_MEA=cta.num_proc_MEA
----			Left Join Caixa_MAS_exp_aer CXA on CTA.num_proc_MEA=CXA.num_proc_MEA AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEA=CXA.DC_MEA and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_MEA,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_MEA
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
----		Where
----			cd_Tp_Ativ='AGT' and desp_DST_MEA='N' and cxa.num_lcto is NOT null
----			and convert(datetime,dt_ins_MEA,103) between @DataInicial and @DataFinal
----			and apelido like @Agente

----		UNION ALL
----		select 
----			Dt_Ins_MIM Data,MAWB_MIM,CTA.num_proc_MIM,Apelido,Nome_tp_TX_ing,Mawb_MIM,Nome_tp_Moeda,cta.dc_MIM,vlr_org_MIM,CTA.Num_DCN_MIM,cta.cd_tp_moeda,CXA.Par_Moeda_MIM Paridade
----		From 
----			cta_cte_MAS_imp_MAR CTA
----			Join MASTER_Imp_MAR HOU on hou.num_proc_MIM=cta.num_proc_MIM
----			Left Join Caixa_MAS_imp_MAR CXA on CTA.num_proc_MIM=CXA.num_proc_MIM AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MIM=CXA.DC_MIM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_MIM,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_MIM
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
----		Where
----			cd_Tp_Ativ='AGT' and desp_org_MIM='N' and cxa.num_lcto is NOT null
----			and convert(datetime,dt_ins_MIM,103) between @DataInicial and @DataFinal
----			and apelido like @Agente

----		UNION ALL
----		select 
----			Dt_Ins_MEM Data, MaWB_MEM,CTA.num_proc_MEM,Apelido,Nome_tp_TX_ing,Mawb_MEM,Nome_tp_Moeda,cta.dc_MEM,vlr_org_MEM,CTA.Num_DCN_MEM ,cta.cd_Tp_moeda,CXA.Par_Moeda_MEM Paridade
----		From 
----			cta_cte_MAS_exp_MAR CTA
----			Join MASTER_exp_MAR HOU on hou.num_proc_MEM=cta.num_proc_MEM
----			Left Join Caixa_MAS_exp_MAR CXA on CTA.num_proc_MEM=CXA.num_proc_MEM AND CTA.cd_tp_tx=CXA.CD_TP_TX AND CTA.DC_MEM=CXA.DC_MEM and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_Rcto_MEM,105)<=@DataPgto
----			Join Pessoa PP on PP.cd_pes=cd_cred_dev_MEM
----			Join Tipo_Taxa TT on TT.cd_tp_tx=cta.CD_tP_tX
----			Join Tipo_Moeda TM on TM.cd_tp_moeda=cta.cd_tp_moeda
----		Where
----			cd_Tp_Ativ='AGT' and desp_DST_MEM='N' and cxa.num_lcto is NOT null
----			and convert(datetime,dt_ins_MEM,103) between @DataInicial and @DataFinal
----			and apelido like @Agente

----	END












GO
