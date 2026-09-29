SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    Procedure spContRESVAR 
			(
				@DataInicial	Char(10),
				@DataFinal	Char(10),
				@dc		Char(1)
			)
AS

select 
	CXA.num_proc_hia, Nome_Tp_Tx, cxa.dc_hia, CXA.vlr_pgto_Rcto_hia, 
	CXO.vlr_pgto_Rcto_hia Caixa_HOU, CXM.vlr_pgto_rcto_mia Caixa_MAS,CXM.Par_Moeda_mia,Isnull(CTM.cd_tp_Moeda,'NAO') CTA_MAS, IsNull(CTO.cd_tp_moeda,'NAO') CTA_HOU,Isnull(CXO.dt_pgto_rcto_hia,'31/12/2006') DT_CXO,IsNull(CXM.dt_pgto_Rcto_mia,'31/12/2006') Dt_CXM, CXA.vlr_ref_hia VLR_REF,CXA.dt_pgto_Rcto_hia Dt_Pgto
from 
	caixa_hou_imp_aer CXA
	Left Join Cta_CtE_hou_imp_Aer CTO on CXA.num_proc_hia=CTO.num_proc_hia and CXA.cd_tp_Tx=CTO.cd_tp_Tx and CXA.dc_hia <> CTO.DC_hia and CTO.desp_org_hia='N' and convert(datetime,CTO.dt_ins_hia,105)<='12-31-2005' and CTO.num_nf_hia is null
	Left Join Cta_Cte_mas_imp_aer CTM on left(CXA.num_proc_hia,14)=CTM.num_proc_mia and CXA.cd_tp_Tx=CTM.cd_tp_Tx and CXA.dc_hia <> CTM.dc_mia and CTM.desp_org_mia='N' and convert(Datetime,CTM.dt_ins_mia,105)<='12-31-2005' and CTM.num_nf_mia is null
	Left Join Caixa_hou_imp_aer CXO on CTO.num_proc_hia=CXO.num_proc_hia and CTO.cd_tp_tx=CXO.cd_tp_Tx and CTO.dc_hia=CXO.dc_hia and CXO.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxo.dt_pgto_Rcto_hia,105) <=convert(Datetime,cxa.dt_pgto_rcto_hia,105)
	Left Join Caixa_mas_imp_aer CXM on CTM.num_proc_mia=CXM.num_proc_mia and CTM.cd_tp_tx=CXM.cd_tp_Tx and CTM.dc_mia=CXM.dc_mia and CXM.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxM.dt_pgto_Rcto_mia,105) <= convert(Datetime,cxa.dt_pgto_rcto_hia,105)
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CXA.cd_Tp_tx
	Join CtA_ctE_hou_imp_Aer CTA on CTa.num_proc_hia=CXa.num_proc_hia and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hia=CXA.dc_hia
	Join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto and num_ctA_cte <> '007'
Where
	CXA.num_lcto <> 'PROVISÓRIO'
	and convert(datetime,cxa.dt_pgto_Rcto_hia,105)between @DataInicial and @DataFinal and CtA.num_nf_hia is null
	and CXA.dc_hia=@DC
	and convert(datetime,CTA.dt_ins_hia,105) <='12-31-2005'
	AND cxa.cd_Tp_tx not in (select * from param_aekContabil_Taxas_exc)
	and pg.num_lcto is not null

union all

select 
	CXA.num_proc_mia, Nome_Tp_Tx, cxa.dc_mia, CXA.vlr_pgto_Rcto_mia, 
	CXO.vlr_pgto_Rcto_mia Caixa_HOU, CXM.vlr_pgto_rcto_hia Caixa_MAS,CXM.Par_Moeda_hia,Isnull(CTM.cd_tp_Moeda,'NAO') CTA_MAS, IsNull(CTO.cd_tp_moeda,'NAO') CTA_HOU,
	IsNull(CXO.dt_pgto_Rcto_mia,'31/12/2006') dt_CXO,IsNull(CXM.dt_pgto_Rcto_hia,'31/12/2006') dt_CXM ,CXA.Vlr_Ref_mia Vlr_Ref, CXA.dt_pgto_Rcto_mia Dt_Pgto
from 
	caixa_mas_imp_aer CXA
	Left Join Cta_CtE_mas_imp_Aer CTO on CXA.num_proc_mia=CTO.num_proc_mia and CXA.cd_tp_Tx=CTO.cd_tp_Tx and CXA.dc_mia <> CTO.DC_mia and CTO.desp_org_mia='N' AND convert(datetime,CTO.dt_ins_mia,105)<='12-31-2005' and cto.num_nf_mia is null
	Left Join Cta_Cte_hou_imp_aer CTM on CXA.num_proc_mia=left(CTM.num_proc_hia,14) and CXA.cd_tp_Tx=CTM.cd_tp_Tx and CXA.dc_mia <> CTM.dc_hia and CTM.desp_org_hia='N' and convert(datetime,CTM.dt_ins_hia,105)<='12-31-2005' and ctm.num_nf_hia is null
	Left Join Caixa_mas_imp_aer CXO on CTO.num_proc_mia=CXO.num_proc_mia and CTO.cd_tp_tx=CXO.cd_tp_Tx and CTO.dc_mia=CXO.dc_mia and CXO.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxo.dt_pgto_Rcto_mia,105) <=convert(Datetime,cxa.dt_pgto_rcto_mia,105)
	Left Join Caixa_hou_imp_aer CXM on CTM.num_proc_hia=CXM.num_proc_hia and CTM.cd_tp_tx=CXM.cd_tp_Tx and CTM.dc_hia=CXM.dc_hia and CXM.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxM.dt_pgto_Rcto_hia,105) <= convert(Datetime,cxa.dt_pgto_rcto_mia,105)
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CXA.cd_Tp_tx
	Join Cta_cte_mas_imp_aer CTA on CTa.num_proc_mia=CXA.num_proc_mia and CTa.cd_tp_Tx=CXA.cd_tp_tx and CTA.dC_mia=CXA.dc_mia
	Join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto and num_ctA_cte <> '007'
Where
	CXA.num_lcto <> 'PROVISÓRIO'
	and convert(datetime,cxa.dt_pgto_Rcto_mia,105)between @DataInicial and @DataFinal and CTA.num_nf_mia is null
	and cxa.dc_mia=@DC
	and convert(Datetime,CTa.dt_ins_mia,105)<='12-31-2005'
	AND cxa.cd_Tp_tx not in (select * from param_aekContabil_Taxas_exc)
	and pg.num_lcto is not null

UNION ALL


select 
	CXA.num_proc_hea, Nome_Tp_Tx, cxa.dc_hea, CXA.vlr_pgto_Rcto_hea, 
	CXO.vlr_pgto_Rcto_hea Caixa_HOU, CXM.vlr_pgto_rcto_mea Caixa_MAS,CXM.Par_Moeda_mea,Isnull(CTM.cd_tp_Moeda,'NAO') CTA_MAS, IsNull(CTO.cd_tp_moeda,'NAO') CTA_HOU,Isnull(CXO.dt_pgto_rcto_hea,'31/12/2006') DT_CXO,IsNull(CXM.dt_pgto_Rcto_mea,'31/12/2006') Dt_CXM, CXA.vlr_ref_hea VLR_REF,CXA.dt_pgto_Rcto_hea Dt_Pgto
from 
	caixa_hou_exp_aer CXA
	Left Join Cta_CtE_hou_exp_Aer CTO on CXA.num_proc_hea=CTO.num_proc_hea and CXA.cd_tp_Tx=CTO.cd_tp_Tx and CXA.dc_hea <> CTO.DC_hea and CTO.desp_dst_hea='N' and convert(datetime,CTO.dt_ins_hea,105)<='12-31-2005' and CTO.num_nf_hea is null
	Left Join Cta_Cte_mas_exp_aer CTM on left(CXA.num_proc_hea,14)=CTM.num_proc_mea and CXA.cd_tp_Tx=CTM.cd_tp_Tx and CXA.dc_hea <> CTM.dc_mea and CTM.desp_dst_mea='N' and convert(Datetime,CTM.dt_ins_mea,105)<='12-31-2005' and CTM.num_nf_mea is null
	Left Join Caixa_hou_exp_aer CXO on CTO.num_proc_hea=CXO.num_proc_hea and CTO.cd_tp_tx=CXO.cd_tp_Tx and CTO.dc_hea=CXO.dc_hea and CXO.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxo.dt_pgto_Rcto_hea,105) <=convert(Datetime,cxa.dt_pgto_rcto_hea,105)
	Left Join Caixa_mas_exp_aer CXM on CTM.num_proc_mea=CXM.num_proc_mea and CTM.cd_tp_tx=CXM.cd_tp_Tx and CTM.dc_mea=CXM.dc_mea and CXM.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxM.dt_pgto_Rcto_mea,105) <= convert(Datetime,cxa.dt_pgto_rcto_hea,105)
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CXA.cd_Tp_tx
	Join CtA_ctE_hou_exp_Aer CTA on CTa.num_proc_hea=CXa.num_proc_hea and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hea=CXA.dc_hea
	Join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto and num_ctA_cte <> '007'
Where
	CXA.num_lcto <> 'PROVISÓRIO'
	and convert(datetime,cxa.dt_pgto_Rcto_hea,105)between @DataInicial and @DataFinal and CtA.num_nf_hea is null
	and CXA.dc_hea=@DC
	and convert(datetime,CTA.dt_ins_hea,105) <='12-31-2005'
	AND cxa.cd_Tp_tx not in (select * from param_aekContabil_Taxas_exc)
	and pg.num_lcto is not null

union all

select 
	CXA.num_proc_mea, Nome_Tp_Tx, cxa.dc_mea, CXA.vlr_pgto_Rcto_mea, 
	CXO.vlr_pgto_Rcto_mea Caixa_HOU, CXM.vlr_pgto_rcto_hea Caixa_MAS,CXM.Par_Moeda_hea,Isnull(CTM.cd_tp_Moeda,'NAO') CTA_MAS, IsNull(CTO.cd_tp_moeda,'NAO') CTA_HOU,
	IsNull(CXO.dt_pgto_Rcto_mea,'31/12/2006') dt_CXO,IsNull(CXM.dt_pgto_Rcto_hea,'31/12/2006') dt_CXM ,CXA.Vlr_Ref_mea Vlr_Ref, CXA.dt_pgto_Rcto_mea Dt_Pgto
from 
	caixa_mas_exp_aer CXA
	Left Join Cta_CtE_mas_exp_Aer CTO on CXA.num_proc_mea=CTO.num_proc_mea and CXA.cd_tp_Tx=CTO.cd_tp_Tx and CXA.dc_mea <> CTO.DC_mea and CTO.desp_dst_mea='N' AND convert(datetime,CTO.dt_ins_mea,105)<='12-31-2005' and cto.num_nf_mea is null
	Left Join Cta_Cte_hou_exp_aer CTM on CXA.num_proc_mea=left(CTM.num_proc_hea,14) and CXA.cd_tp_Tx=CTM.cd_tp_Tx and CXA.dc_mea <> CTM.dc_hea and CTM.desp_dst_hea='N' and convert(datetime,CTM.dt_ins_hea,105)<='12-31-2005' and ctm.num_nf_hea is null
	Left Join Caixa_mas_exp_aer CXO on CTO.num_proc_mea=CXO.num_proc_mea and CTO.cd_tp_tx=CXO.cd_tp_Tx and CTO.dc_mea=CXO.dc_mea and CXO.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxo.dt_pgto_Rcto_mea,105) <=convert(Datetime,cxa.dt_pgto_rcto_mea,105)
	Left Join Caixa_hou_exp_aer CXM on CTM.num_proc_hea=CXM.num_proc_hea and CTM.cd_tp_tx=CXM.cd_tp_Tx and CTM.dc_hea=CXM.dc_hea and CXM.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxM.dt_pgto_Rcto_hea,105) <= convert(Datetime,cxa.dt_pgto_rcto_mea,105)
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CXA.cd_Tp_tx
	Join Cta_cte_mas_exp_aer CTA on CTa.num_proc_mea=CXA.num_proc_mea and CTa.cd_tp_Tx=CXA.cd_tp_tx and CTA.dC_mea=CXA.dc_mea
	Join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto and num_ctA_cte <> '007'
Where
	CXA.num_lcto <> 'PROVISÓRIO'
	and convert(datetime,cxa.dt_pgto_Rcto_mea,105)between @DataInicial and @DataFinal and CTA.num_nf_mea is null
	and cxa.dc_mea=@DC
	and convert(Datetime,CTa.dt_ins_mea,105)<='12-31-2005'
	AND cxa.cd_Tp_tx not in (select * from param_aekContabil_Taxas_exc)
	AND pg.num_lcto is not null

UNION ALL


select 
	CXA.num_proc_HIM, Nome_Tp_Tx, cxa.dc_HIM, CXA.vlr_pgto_Rcto_HIM, 
	CXO.vlr_pgto_Rcto_HIM Caixa_HOU, CXM.vlr_pgto_rcto_MIM Caixa_MAS,CXM.Par_Moeda_MIM,Isnull(CTM.cd_tp_Moeda,'NAO') CTA_MAS, IsNull(CTO.cd_tp_moeda,'NAO') CTA_HOU,Isnull(CXO.dt_pgto_rcto_HIM,'31/12/2006') DT_CXO,IsNull(CXM.dt_pgto_Rcto_MIM,'31/12/2006') Dt_CXM, CXA.vlr_ref_HIM VLR_REF,CXA.dt_pgto_Rcto_HIM Dt_Pgto
from 
	caixa_hou_imp_MAR CXA
	Left Join Cta_CtE_hou_imp_MAR CTO on CXA.num_proc_HIM=CTO.num_proc_HIM and CXA.cd_tp_Tx=CTO.cd_tp_Tx and CXA.dc_HIM <> CTO.DC_HIM and CTO.desp_org_HIM='N' and convert(datetime,CTO.dt_ins_HIM,105)<='12-31-2005' and CTO.num_nf_HIM is null
	Left Join Cta_Cte_mas_imp_MAR CTM on left(CXA.num_proc_HIM,14)=CTM.num_proc_MIM and CXA.cd_tp_Tx=CTM.cd_tp_Tx and CXA.dc_HIM <> CTM.dc_MIM and CTM.desp_org_MIM='N' and convert(Datetime,CTM.dt_ins_MIM,105)<='12-31-2005' and CTM.num_nf_MIM is null
	Left Join Caixa_hou_imp_MAR CXO on CTO.num_proc_HIM=CXO.num_proc_HIM and CTO.cd_tp_tx=CXO.cd_tp_Tx and CTO.dc_HIM=CXO.dc_HIM and CXO.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxo.dt_pgto_Rcto_HIM,105) <=convert(Datetime,cxa.dt_pgto_rcto_HIM,105)
	Left Join Caixa_mas_imp_MAR CXM on CTM.num_proc_MIM=CXM.num_proc_MIM and CTM.cd_tp_tx=CXM.cd_tp_Tx and CTM.dc_MIM=CXM.dc_MIM and CXM.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxM.dt_pgto_Rcto_MIM,105) <= convert(Datetime,cxa.dt_pgto_rcto_HIM,105)
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CXA.cd_Tp_tx
	Join CtA_ctE_hou_imp_MAR CTA on CTa.num_proc_HIM=CXa.num_proc_HIM and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_HIM=CXA.dc_HIM
	Join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto and num_ctA_cte <> '007'
Where
	CXA.num_lcto <> 'PROVISÓRIO'
	and convert(datetime,cxa.dt_pgto_Rcto_HIM,105)between @DataInicial and @DataFinal and CtA.num_nf_HIM is null
	and CXA.dc_HIM=@DC
	and convert(datetime,CTA.dt_ins_HIM,105) <='12-31-2005'
	AND cxa.cd_Tp_tx not in (select * from param_aekContabil_Taxas_exc)
	and pg.num_lcto is not null

union all

select 
	CXA.num_proc_MIM, Nome_Tp_Tx, cxa.dc_MIM, CXA.vlr_pgto_Rcto_MIM, 
	CXO.vlr_pgto_Rcto_MIM Caixa_HOU, CXM.vlr_pgto_rcto_HIM Caixa_MAS,CXM.Par_Moeda_HIM,Isnull(CTM.cd_tp_Moeda,'NAO') CTA_MAS, IsNull(CTO.cd_tp_moeda,'NAO') CTA_HOU,
	IsNull(CXO.dt_pgto_Rcto_MIM,'31/12/2006') dt_CXO,IsNull(CXM.dt_pgto_Rcto_HIM,'31/12/2006') dt_CXM ,CXA.Vlr_Ref_MIM Vlr_Ref, CXA.dt_pgto_Rcto_MIM Dt_Pgto
from 
	caixa_mas_imp_MAR CXA
	Left Join Cta_CtE_mas_imp_MAR CTO on CXA.num_proc_MIM=CTO.num_proc_MIM and CXA.cd_tp_Tx=CTO.cd_tp_Tx and CXA.dc_MIM <> CTO.DC_MIM and CTO.desp_org_MIM='N' AND convert(datetime,CTO.dt_ins_MIM,105)<='12-31-2005' and cto.num_nf_MIM is null
	Left Join Cta_Cte_hou_imp_MAR CTM on CXA.num_proc_MIM=left(CTM.num_proc_HIM,14) and CXA.cd_tp_Tx=CTM.cd_tp_Tx and CXA.dc_MIM <> CTM.dc_HIM and CTM.desp_org_HIM='N' and convert(datetime,CTM.dt_ins_HIM,105)<='12-31-2005' and ctm.num_nf_HIM is null
	Left Join Caixa_mas_imp_MAR CXO on CTO.num_proc_MIM=CXO.num_proc_MIM and CTO.cd_tp_tx=CXO.cd_tp_Tx and CTO.dc_MIM=CXO.dc_MIM and CXO.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxo.dt_pgto_Rcto_MIM,105) <=convert(Datetime,cxa.dt_pgto_rcto_MIM,105)
	Left Join Caixa_hou_imp_MAR CXM on CTM.num_proc_HIM=CXM.num_proc_HIM and CTM.cd_tp_tx=CXM.cd_tp_Tx and CTM.dc_HIM=CXM.dc_HIM and CXM.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxM.dt_pgto_Rcto_HIM,105) <= convert(Datetime,cxa.dt_pgto_rcto_MIM,105)
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CXA.cd_Tp_tx
	Join Cta_cte_mas_imp_MAR CTA on CTa.num_proc_MIM=CXA.num_proc_MIM and CTa.cd_tp_Tx=CXA.cd_tp_tx and CTA.dC_MIM=CXA.dc_MIM
	Join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto and num_ctA_cte <> '007'
Where
	CXA.num_lcto <> 'PROVISÓRIO'
	and convert(datetime,cxa.dt_pgto_Rcto_MIM,105)between @DataInicial and @DataFinal and CTA.num_nf_MIM is null
	and cxa.dc_MIM=@DC
	and convert(Datetime,CTa.dt_ins_MIM,105)<='12-31-2005'
	AND cxa.cd_Tp_tx not in (select * from param_aekContabil_Taxas_exc)
	and pg.num_lcto is not null

UNION ALL


select 
	CXA.num_proc_HEM, Nome_Tp_Tx, cxa.dc_HEM, CXA.vlr_pgto_Rcto_HEM, 
	CXO.vlr_pgto_Rcto_HEM Caixa_HOU, CXM.vlr_pgto_rcto_MEM Caixa_MAS,CXM.Par_Moeda_MEM,Isnull(CTM.cd_tp_Moeda,'NAO') CTA_MAS, IsNull(CTO.cd_tp_moeda,'NAO') CTA_HOU,Isnull(CXO.dt_pgto_rcto_HEM,'31/12/2006') DT_CXO,IsNull(CXM.dt_pgto_Rcto_MEM,'31/12/2006') Dt_CXM, CXA.vlr_ref_HEM VLR_REF,CXA.dt_pgto_Rcto_HEM Dt_Pgto
from 
	caixa_hou_exp_MAR CXA
	Left Join Cta_CtE_hou_exp_MAR CTO on CXA.num_proc_HEM=CTO.num_proc_HEM and CXA.cd_tp_Tx=CTO.cd_tp_Tx and CXA.dc_HEM <> CTO.DC_HEM and CTO.desp_dst_HEM='N' and convert(datetime,CTO.dt_ins_HEM,105)<='12-31-2005' and CTO.num_nf_HEM is null
	Left Join Cta_Cte_mas_exp_MAR CTM on left(CXA.num_proc_HEM,14)=CTM.num_proc_MEM and CXA.cd_tp_Tx=CTM.cd_tp_Tx and CXA.dc_HEM <> CTM.dc_MEM and CTM.desp_dst_MEM='N' and convert(Datetime,CTM.dt_ins_MEM,105)<='12-31-2005' and CTM.num_nf_MEM is null
	Left Join Caixa_hou_exp_MAR CXO on CTO.num_proc_HEM=CXO.num_proc_HEM and CTO.cd_tp_tx=CXO.cd_tp_Tx and CTO.dc_HEM=CXO.dc_HEM and CXO.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxo.dt_pgto_Rcto_HEM,105) <=convert(Datetime,cxa.dt_pgto_rcto_HEM,105)
	Left Join Caixa_mas_exp_MAR CXM on CTM.num_proc_MEM=CXM.num_proc_MEM and CTM.cd_tp_tx=CXM.cd_tp_Tx and CTM.dc_MEM=CXM.dc_MEM and CXM.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxM.dt_pgto_Rcto_MEM,105) <= convert(Datetime,cxa.dt_pgto_rcto_HEM,105)
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CXA.cd_Tp_tx
	Join CtA_ctE_hou_exp_MAR CTA on CTa.num_proc_HEM=CXa.num_proc_HEM and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_HEM=CXA.dc_HEM
	Join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto and num_ctA_cte <> '007'
Where
	CXA.num_lcto <> 'PROVISÓRIO'
	and convert(datetime,cxa.dt_pgto_Rcto_HEM,105)between @DataInicial and @DataFinal and CtA.num_nf_HEM is null
	and CXA.dc_HEM=@DC
	and convert(datetime,CTA.dt_ins_HEM,105) <='12-31-2005'
	AND cxa.cd_Tp_tx not in (select * from param_aekContabil_Taxas_exc)
	and pg.num_lcto is not null

union all

select 
	CXA.num_proc_MEM, Nome_Tp_Tx, cxa.dc_MEM, CXA.vlr_pgto_Rcto_MEM, 
	CXO.vlr_pgto_Rcto_MEM Caixa_HOU, CXM.vlr_pgto_rcto_HEM Caixa_MAS,CXM.Par_Moeda_HEM,Isnull(CTM.cd_tp_Moeda,'NAO') CTA_MAS, IsNull(CTO.cd_tp_moeda,'NAO') CTA_HOU,
	IsNull(CXO.dt_pgto_Rcto_MEM,'31/12/2006') dt_CXO,IsNull(CXM.dt_pgto_Rcto_HEM,'31/12/2006') dt_CXM ,CXA.Vlr_Ref_MEM Vlr_Ref, CXA.dt_pgto_Rcto_MEM Dt_Pgto
from 
	caixa_mas_exp_MAR CXA
	Left Join Cta_CtE_mas_exp_MAR CTO on CXA.num_proc_MEM=CTO.num_proc_MEM and CXA.cd_tp_Tx=CTO.cd_tp_Tx and CXA.dc_MEM <> CTO.DC_MEM and CTO.desp_dst_MEM='N' AND convert(datetime,CTO.dt_ins_MEM,105)<='12-31-2005' and cto.num_nf_MEM is null
	Left Join Cta_Cte_hou_exp_MAR CTM on CXA.num_proc_MEM=left(CTM.num_proc_HEM,14) and CXA.cd_tp_Tx=CTM.cd_tp_Tx and CXA.dc_MEM <> CTM.dc_HEM and CTM.desp_dst_HEM='N' and convert(datetime,CTM.dt_ins_HEM,105)<='12-31-2005' and ctm.num_nf_HEM is null
	Left Join Caixa_mas_exp_MAR CXO on CTO.num_proc_MEM=CXO.num_proc_MEM and CTO.cd_tp_tx=CXO.cd_tp_Tx and CTO.dc_MEM=CXO.dc_MEM and CXO.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxo.dt_pgto_Rcto_MEM,105) <=convert(Datetime,cxa.dt_pgto_rcto_MEM,105)
	Left Join Caixa_hou_exp_MAR CXM on CTM.num_proc_HEM=CXM.num_proc_HEM and CTM.cd_tp_tx=CXM.cd_tp_Tx and CTM.dc_HEM=CXM.dc_HEM and CXM.num_lcto <> 'PROVISÓRIO' and convert(Datetime,cxM.dt_pgto_Rcto_HEM,105) <= convert(Datetime,cxa.dt_pgto_rcto_MEM,105)
	Join Tipo_Taxa TT on TT.cd_tp_Tx=CXA.cd_Tp_tx
	Join Cta_cte_mas_exp_MAR CTA on CTa.num_proc_MEM=CXA.num_proc_MEM and CTa.cd_tp_Tx=CXA.cd_tp_tx and CTA.dC_MEM=CXA.dc_MEM
	Join Pgto_Rcto PG on PG.num_lcto=CXA.num_lcto and num_ctA_cte <> '007'
Where
	CXA.num_lcto <> 'PROVISÓRIO'
	and convert(datetime,cxa.dt_pgto_Rcto_MEM,105)between @DataInicial and @DataFinal and CTA.num_nf_MEM is null
	and cxa.dc_MEM=@DC
	and convert(Datetime,CTa.dt_ins_MEM,105)<='12-31-2005'
	AND cxa.cd_Tp_tx not in (select * from param_aekContabil_Taxas_exc)
	and pg.num_lcto is not null




GO
