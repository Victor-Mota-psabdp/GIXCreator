SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spRecCusClien_Rel	
			(
			   @DataInicial	Varchar(10),
			   @DataFinal   Varchar(10)
			)
as



select 
	Cta.Num_proc_hia Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_hia, CTA.vlr_org_hia, 
	isnull(Vlr_pgto_rcto_hia,0) PG, isnull(OFC.par_moeda,0) Oficial, isnull(PAR.par_moeda,0) Par_Modal,isnull(PGA.num_lcto,'1') PG_AJ   
from 
	cta_ctE_hou_imp_aer CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.dt_par=dt_ins_hia and PAR.cd_tp_par='IMA'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.dt_par=dt_ins_hia and OFC.cd_tp_par='OFC'
	Left Join Caixa_hou_imp_aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_hia=CXA.dc_hia and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hia,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_org_hia='N' and convert(datetime,dt_ins_hia,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hia,5) <> 'IAJOB' and 	
	cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
	and pga.num_lcto is null


UNION ALL



select 
	Cta.Num_proc_mia Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_mia, CTA.vlr_org_mia, 
	isnull(Vlr_pgto_rcto_mia,0) PG, isnull(OFC.par_moeda,0) Oficial, isnull(PAR.par_moeda,0) Par_Modal, isnull(PGA.num_lcto,'1')      
from 
	cta_ctE_mas_imp_aer CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.dt_par=dt_ins_mia and PAR.cd_tp_par='IMA'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.dt_par=dt_ins_mia and OFC.cd_tp_par='OFC'
	Left Join Caixa_mas_imp_aer CXA on CTA.num_proc_mia=CXA.num_proc_mia and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_mia=CXA.dc_mia and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mia,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_org_mia='N' and convert(datetime,dt_ins_mia,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
	and pga.num_lcto is null


UNION ALL

select 
	Cta.Num_proc_hea Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_hea, CTA.vlr_org_hea, 
	isnull(Vlr_pgto_rcto_hea,0) PG, isnull(OFC.par_moeda,0) Oficial, isnull(PAR.par_moeda,0) Par_Modal,isnull(PGA.num_lcto,'1')      
from 
	cta_ctE_hou_exp_aer CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.dt_par=dt_ins_hea and PAR.cd_tp_par='EXA'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.dt_par=dt_ins_hea and OFC.cd_tp_par='OFC'
	Left Join Caixa_hou_exp_aer CXA on CTA.num_proc_hea=CXA.num_proc_hea and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_hea=CXA.dc_hea and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hea,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_DST_hea='N' and convert(datetime,dt_ins_hea,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_hea,5) <> 'EAJOB' and 	
	cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
	and pga.num_lcto is null



UNION ALL



select 
	Cta.Num_proc_mea Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_mea, CTA.vlr_org_mea, 
	isnull(Vlr_pgto_rcto_mea,0) PG, isnull(OFC.par_moeda,0) Oficial, isnull(PAR.par_moeda,0) Par_Modal,isnull(PGA.num_lcto,'1')   
from 
	cta_ctE_mas_exp_aer CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.dt_par=dt_ins_mea and PAR.cd_tp_par='EXA'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.dt_par=dt_ins_mea and OFC.cd_tp_par='OFC'
	Left Join Caixa_mas_exp_aer CXA on CTA.num_proc_mea=CXA.num_proc_mea and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_mea=CXA.dc_mea and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_mea,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_DST_mea='N' and convert(datetime,dt_ins_mea,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
	and pga.num_lcto is null


union all


select 
	Cta.Num_proc_HIM Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_HIM, CTA.vlr_org_HIM, 
	isnull(Vlr_pgto_rcto_HIM,0) PG, isnull(OFC.par_moeda,0) Oficial, isnull(PAR.par_moeda,0) Par_Modal,isnull(PGA.num_lcto,'1')   
from 
	cta_ctE_hou_imp_MAR CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.dt_par=dt_ins_HIM and PAR.cd_tp_par='IMM'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.dt_par=dt_ins_HIM and OFC.cd_tp_par='OFC'
	Left Join Caixa_hou_imp_MAR CXA on CTA.num_proc_HIM=CXA.num_proc_HIM and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_HIM=CXA.dc_HIM and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_HIM,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_org_HIM='N' and convert(datetime,dt_ins_HIM,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_HIM,5) <> 'IMJOB' and 	
	cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
	and pga.num_lcto is null


UNION ALL

select 
	Cta.Num_proc_MIM Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_MIM, CTA.vlr_org_MIM, 
	isnull(Vlr_pgto_rcto_MIM,0) PG, isnull(OFC.par_moeda,0) Oficial, isnull(PAR.par_moeda,0) Par_Modal, isnull(PGA.num_lcto,'1')      
from 
	cta_ctE_mas_imp_MAR CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.dt_par=dt_ins_MIM and PAR.cd_tp_par='IMM'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.dt_par=dt_ins_MIM and OFC.cd_tp_par='OFC'
	Left Join Caixa_mas_imp_MAR CXA on CTA.num_proc_MIM=CXA.num_proc_MIM and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_MIM=CXA.dc_MIM and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_MIM,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_org_MIM='N' and convert(datetime,dt_ins_MIM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
	and pga.num_lcto is null


UNION ALL

select 
	Cta.Num_proc_HEM Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_HEM, CTA.vlr_org_HEM, 
	isnull(Vlr_pgto_rcto_HEM,0) PG, isnull(OFC.par_moeda,0) Oficial, isnull(PAR.par_moeda,0) Par_Modal,isnull(PGA.num_lcto,'1')      
from 
	cta_ctE_hou_exp_MAR CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.dt_par=dt_ins_HEM and PAR.cd_tp_par='EXM'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.dt_par=dt_ins_HEM and OFC.cd_tp_par='OFC'
	Left Join Caixa_hou_exp_MAR CXA on CTA.num_proc_HEM=CXA.num_proc_HEM and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_HEM=CXA.dc_HEM and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_HEM,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_DST_HEM='N' and convert(datetime,dt_ins_HEM,105) between @DataInicial and @DataFinal
	and left(cta.num_proc_HEM,5) <> 'EMJOB' and 	
	cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
	and pga.num_lcto is null
	


UNION ALL



select 
	Cta.Num_proc_MEM Processo, CTA.cd_tp_tx, CTA.cd_tp_moeda, CTA.dc_MEM, CTA.vlr_org_MEM, 
	isnull(Vlr_pgto_rcto_MEM,0) PG, isnull(OFC.par_moeda,0) Oficial, isnull(PAR.par_moeda,0) Par_Modal,isnull(PGA.num_lcto,'1')   
from 
	cta_ctE_mas_exp_MAR CTA
	Left Join Paridade PAR on PAR.cd_tp_moeda=CTA.cd_tp_moeda and PAR.dt_par=dt_ins_MEM and PAR.cd_tp_par='EXM'
	Left Join Paridade OFC on OFC.cd_tp_moeda=CTA.cd_tp_moeda and OFC.dt_par=dt_ins_MEM and OFC.cd_tp_par='OFC'
	Left Join Caixa_mas_exp_MAR CXA on CTA.num_proc_MEM=CXA.num_proc_MEM and CTA.cd_tp_Tx=CXA.cd_tp_tx and CTA.dc_MEM=CXA.dc_MEM and NUM_LCTO <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_MEM,105) <=@DataFinal
	Join Tipo_Taxa TT on TT.cd_tp_tx=CTA.cd_tp_tx
	Left Join Pgto_rcto PGA on CXA.num_lcto=PGA.num_lcto and num_ctA_cte <> '007'
Where
	desp_DST_MEM='N' and convert(datetime,dt_ins_MEM,105) between @DataInicial and @DataFinal
	and cta.cd_tp_tx not in ('135','142','ADT','143','149','125')	
	and pga.num_lcto is null




GO
