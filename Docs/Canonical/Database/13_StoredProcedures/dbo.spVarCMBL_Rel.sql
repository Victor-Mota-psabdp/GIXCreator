SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure spVarCMBL_Rel
		@DataInicial	varchar(10),
		@DataFinal	varchar(10)

as

		

select 
	num_ref_ra, cxa.num_proc_hia, nome_tp_tx, cxa.dc_hia, cxa.vlr_ref_hia, cxa.vlr_pgto_rcto_hia,isnull(cxo.vlr_ref_hia,0) Vlr_OPO, 
	isnull(cxo.vlr_pgto_Rcto_hia,0) Vlr_PG_OPO,isnull(cmo.vlr_ref_mia,0) Vlr_OMO,isnull(cmo.vlr_pgto_Rcto_mia,0) Vlr_PG_OMO,	
	CTA.cd_tp_moeda Moeda 

from 
	remessa_aer
	Join Caixa_hou_imp_aer CXA on CXA.num_rcb_hia=num_ref_Ra
	Join Cta_cte_hou_imp_aer cta on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia
	Join Tipo_Taxa TT on TT.cd_tp_tx=CXA.cd_tp_Tx
	Left Join cta_Cte_hou_imp_aer CTO on CTA.num_proc_hia=CTO.num_proc_hia and CTA.cd_tp_tx=CTO.cd_tp_tx and CTA.dc_hia <> cto.dc_hia and cta.cd_tp_moeda=cto.cd_tp_moeda
	left Join Caixa_hou_imp_aer CXO on cto.num_proc_hia=cxo.num_proc_hia and cto.cd_tp_Tx=cxo.cd_tp_tx and cto.dc_hia=cxo.dc_hia and cxo.num_lcto <> 'PROVISÓRIO'
Left Join cta_Cte_mas_imp_aer CMA on left(CTA.num_proc_hia,14)=CMA.num_proc_mia and CTA.cd_tp_tx=CMA.cd_tp_tx and CTA.dc_hia <> cMA.dc_mia and cta.cd_tp_moeda=CMA.cd_tp_moeda
left Join Caixa_MAS_imp_aer CMO on CMA.num_proc_mia=cmo.num_proc_mia and cma.cd_tp_tx=cmo.cd_tp_Tx and cma.dc_mia=cmo.dc_mia and cMo.num_lcto <> 'PROVISÓRIO'
where convert(Datetime,dt_ra,105) between @DataInicial and @DataFinal

UNION

select 
	num_ref_ra, cxa.num_proc_hea, nome_tp_tx, cxa.dc_hea, cxa.vlr_ref_hea, cxa.vlr_pgto_rcto_hea,isnull(cxo.vlr_ref_hea,0) 
	Vlr_OPO, isnull(cxo.vlr_pgto_Rcto_hea,0) Vlr_PG_OPO,isnull(cmo.vlr_ref_mea,0) Vlr_OMO,isnull(cmo.vlr_pgto_Rcto_mea,0) Vlr_PG_OMO,
	CTA.cd_tp_moeda Moeda 
	
from 
	remessa_aer
	Join Caixa_hou_exp_aer CXA on CXA.num_rcb_hea=num_ref_Ra
	Join Cta_cte_hou_exp_aer cta on cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea
	Join Tipo_Taxa TT on TT.cd_tp_tx=CXA.cd_tp_Tx
	Left Join cta_Cte_hou_exp_aer CTO on CTA.num_proc_hea=CTO.num_proc_hea and CTA.cd_tp_tx=CTO.cd_tp_tx and CTA.dc_hea <> cto.dc_hea and cta.cd_tp_moeda=cto.cd_tp_moeda
	left Join Caixa_hou_exp_aer CXO on cto.num_proc_hea=cxo.num_proc_hea and cto.cd_tp_Tx=cxo.cd_tp_tx and cto.dc_hea=cxo.dc_hea and cxo.num_lcto <> 'PROVISÓRIO'
	Left Join cta_Cte_mas_exp_aer CMA on left(CTA.num_proc_hea,14)=CMA.num_proc_mea and CTA.cd_tp_tx=CMA.cd_tp_tx and CTA.dc_hea <> cMA.dc_mea and cta.cd_tp_moeda=CMA.cd_tp_moeda
	left Join Caixa_MAS_exp_aer CMO on CMA.num_proc_mea=cmo.num_proc_mea and cma.cd_tp_tx=cmo.cd_tp_Tx and cma.dc_mea=cmo.dc_mea and cMo.num_lcto <> 'PROVISÓRIO'
where 
	convert(Datetime,dt_ra,105) between @DataInicial and @DataFinal

UNION

select 
	num_ref_rm, cxa.num_proc_him, nome_tp_tx, cxa.dc_him, cxa.vlr_ref_him, cxa.vlr_pgto_rcto_him,isnull(cxo.vlr_ref_him,0) Vlr_OPO, 
	isnull(cxo.vlr_pgto_Rcto_him,0) Vlr_PG_OPO,isnull(cmo.vlr_ref_mim,0) Vlr_OMO,isnull(cmo.vlr_pgto_Rcto_mim,0) Vlr_PG_OMO,	
	CTA.cd_tp_moeda Moeda 

from 
	remessa_mar
	Join Caixa_hou_imp_mar CXA on CXA.num_rcb_him=num_ref_rm
	Join Cta_cte_hou_imp_mar cta on cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him
	Join Tipo_Taxa TT on TT.cd_tp_tx=CXA.cd_tp_Tx
	Left Join cta_Cte_hou_imp_mar CTO on CTA.num_proc_him=CTO.num_proc_him and CTA.cd_tp_tx=CTO.cd_tp_tx and CTA.dc_him <> cto.dc_him and cta.cd_tp_moeda=cto.cd_tp_moeda
	left Join Caixa_hou_imp_mar CXO on cto.num_proc_him=cxo.num_proc_him and cto.cd_tp_Tx=cxo.cd_tp_tx and cto.dc_him=cxo.dc_him and cxo.num_lcto <> 'PROVISÓRIO'
Left Join cta_Cte_mas_imp_mar CMA on left(CTA.num_proc_him,14)=CMA.num_proc_mim and CTA.cd_tp_tx=CMA.cd_tp_tx and CTA.dc_him <> cMA.dc_mim and cta.cd_tp_moeda=CMA.cd_tp_moeda
left Join Caixa_MAS_imp_mar CMO on CMA.num_proc_mim=cmo.num_proc_mim and cma.cd_tp_tx=cmo.cd_tp_Tx and cma.dc_mim=cmo.dc_mim and cMo.num_lcto <> 'PROVISÓRIO'
where convert(Datetime,dt_rm,105) between @DataInicial and @DataFinal

UNION

select 
	num_ref_rm, cxa.num_proc_hem, nome_tp_tx, cxa.dc_hem, cxa.vlr_ref_hem, cxa.vlr_pgto_rcto_hem,isnull(cxo.vlr_ref_hem,0) 
	Vlr_OPO, isnull(cxo.vlr_pgto_Rcto_hem,0) Vlr_PG_OPO,isnull(cmo.vlr_ref_mem,0) Vlr_OMO,isnull(cmo.vlr_pgto_Rcto_mem,0) Vlr_PG_OMO,
	CTA.cd_tp_moeda Moeda 
	
from 
	remessa_mar
	Join Caixa_hou_exp_mar CXA on CXA.num_rcb_hem=num_ref_rm
	Join Cta_cte_hou_exp_mar cta on cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem
	Join Tipo_Taxa TT on TT.cd_tp_tx=CXA.cd_tp_Tx
	Left Join cta_Cte_hou_exp_mar CTO on CTA.num_proc_hem=CTO.num_proc_hem and CTA.cd_tp_tx=CTO.cd_tp_tx and CTA.dc_hem <> cto.dc_hem and cta.cd_tp_moeda=cto.cd_tp_moeda
	left Join Caixa_hou_exp_mar CXO on cto.num_proc_hem=cxo.num_proc_hem and cto.cd_tp_Tx=cxo.cd_tp_tx and cto.dc_hem=cxo.dc_hem and cxo.num_lcto <> 'PROVISÓRIO'
	Left Join cta_Cte_mas_exp_mar CMA on left(CTA.num_proc_hem,14)=CMA.num_proc_mem and CTA.cd_tp_tx=CMA.cd_tp_tx and CTA.dc_hem <> cMA.dc_mem and cta.cd_tp_moeda=CMA.cd_tp_moeda
	left Join Caixa_MAS_exp_mar CMO on CMA.num_proc_mem=cmo.num_proc_mem and cma.cd_tp_tx=cmo.cd_tp_Tx and cma.dc_mem=cmo.dc_mem and cMo.num_lcto <> 'PROVISÓRIO'
where 
	convert(Datetime,dt_rm,105) between @DataInicial and @DataFinal







GO
