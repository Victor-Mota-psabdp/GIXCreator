SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure SpVar 

		@datainicial varchar(10),
		@datafinal varchar(10)
AS

select 
	cxa.num_proc_hia,Convert(datetime,CXA.dt_pgto_rcto_hia,105) DataPgto,Nome_tp_tx,CXA.DC_HIA,CXA.vlr_ref_hia Vlr_Pgto,CXA.Par_moeda_hia ParCXA,CXM.Par_moeda_Mia ParCXM, CXO.Par_moeda_hia ParCXO
from 
	caixA_hou_imp_aer cxa
	Join Cta_cte_hou_imp_aer CTA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hia=CXA.dc_hia
	Join Tipo_taxa TT on TT.cd_tp_tx=CXA.cd_tp_tx
	Left Join Cta_cte_hou_imp_aer CTO on CTA.num_proc_hia=CTO.num_proc_hia and CTA.cd_tp_tx=CTO.cd_tp_Tx and CTA.dc_hia<>CTO.dc_hia and CTA.cd_tp_moeda=CTO.cd_tp_moeda
	LEFT Join Caixa_hou_imp_aer CXO on CTO.num_proc_hia=CXO.num_proc_hia and CTO.cd_tp_tx=CXO.cd_tp_tx and CTO.dc_hia=CXO.dc_hia and Convert(datetime,CXO.dt_pgto_rcto_hia,105) <=Convert(datetime,CXA.dt_pgto_rcto_hia,105) and CXO.num_lcto <> 'PROVISÓRIO'
	Left Join Cta_cte_MAS_imp_aer CTM on LEFT(CTA.num_proc_hia,14)=CTM.num_proc_Mia and CTA.cd_tp_tx=CTM.cd_tp_Tx and CTA.dc_hia<>CTM.dc_Mia and CTA.cd_tp_moeda=CTM.cd_tp_moeda
	LEFT Join Caixa_MAS_imp_aer CXM on CTM.num_proc_Mia=CXM.num_proc_Mia and CTM.cd_tp_tx=CXM.cd_tp_tx and CTM.dc_Mia=CXM.dc_Mia and Convert(datetime,CXM.dt_pgto_rcto_mia,105) <=Convert(datetime,CXA.dt_pgto_rcto_hia,105) and CXM.num_lcto <> 'PROVISÓRIO'

WHERE
	cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime,CXA.dt_pgto_rcto_hia,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
	AND (CXO.Par_moeda_hia is not null or CXM.Par_moeda_mia is not null)	
	and cta.cd_tp_moeda <> 'REL'
union

select 
	cxa.num_proc_mia,Convert(datetime,CXA.dt_pgto_rcto_mia,105) DataPgto,Nome_tp_tx,CXA.DC_mIA,CXA.vlr_ref_mia Vlr_Pgto,CXA.Par_moeda_mia ParCXA,CXM.Par_moeda_hia ParCXM, CXO.Par_moeda_Mia ParCXO
from 
	caixA_mas_imp_aer cxa
	Join Cta_cte_mas_imp_aer CTA on CTA.num_proc_mia=CXA.num_proc_mia and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_mia=CXA.dc_mia
	Join Tipo_taxa TT on TT.cd_tp_tx=CXA.cd_tp_tx
	Left Join Cta_cte_mas_imp_aer CTO on CTA.num_proc_mia=CTO.num_proc_mia and CTA.cd_tp_tx=CTO.cd_tp_Tx and CTA.dc_mia<>CTO.dc_mia and CTA.cd_tp_moeda=CTO.cd_tp_moeda
	LEFT Join Caixa_mas_imp_aer CXO on CTO.num_proc_mia=CXO.num_proc_mia and CTO.cd_tp_tx=CXO.cd_tp_tx and CTO.dc_mia=CXO.dc_mia and Convert(datetime,CXO.dt_pgto_rcto_mia,105) <=Convert(datetime,CXA.dt_pgto_rcto_mia,105) and CXO.num_lcto <> 'PROVISÓRIO'
	Left Join Cta_cte_HOU_imp_aer CTM on CTA.num_proc_Mia=LEFT(CTM.num_proc_Hia,14) and CTA.cd_tp_tx=CTM.cd_tp_Tx and CTA.dc_Mia<>CTM.dc_Hia and CTA.cd_tp_moeda=CTM.cd_tp_moeda
	LEFT Join Caixa_HOU_imp_aer CXM on CTM.num_proc_Hia=CXM.num_proc_Hia and CTM.cd_tp_tx=CXM.cd_tp_tx and CTM.dc_Hia=CXM.dc_Hia and Convert(datetime,CXM.dt_pgto_rcto_Hia,105) <=Convert(datetime,CXA.dt_pgto_rcto_Mia,105) and CXM.num_lcto <> 'PROVISÓRIO'
WHERE
	cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime,CXA.dt_pgto_rcto_mia,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
	AND (CXO.Par_moeda_mia is not null or CXM.Par_moeda_hia is not null)	
	and cta.cd_tp_moeda <> 'REL'

UNION ALL

--Exportação Aérea
select 
	cxa.num_proc_hea,Convert(datetime,CXA.dt_pgto_rcto_hea,105) DataPgto,Nome_tp_tx,CXA.DC_hea,CXA.vlr_ref_hea Vlr_Pgto,CXA.Par_moeda_hea ParCXA,CXM.Par_moeda_mea ParCXM, CXO.Par_moeda_hea ParCXO
from 
	caixA_hou_exp_aer cxa
	Join Cta_cte_hou_exp_aer CTA on CTA.num_proc_hea=CXA.num_proc_hea and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_hea=CXA.dc_hea
	Join Tipo_taxa TT on TT.cd_tp_tx=CXA.cd_tp_tx
	Left Join Cta_cte_hou_exp_aer CTO on CTA.num_proc_hea=CTO.num_proc_hea and CTA.cd_tp_tx=CTO.cd_tp_Tx and CTA.dc_hea<>CTO.dc_hea and CTA.cd_tp_moeda=CTO.cd_tp_moeda
	LEFT Join Caixa_hou_exp_aer CXO on CTO.num_proc_hea=CXO.num_proc_hea and CTO.cd_tp_tx=CXO.cd_tp_tx and CTO.dc_hea=CXO.dc_hea and Convert(datetime,CXO.dt_pgto_rcto_hea,105) <=Convert(datetime,CXA.dt_pgto_rcto_hea,105) and CXO.num_lcto <> 'PROVISÓRIO'
	Left Join Cta_cte_MAS_exp_aer CTM on LEFT(CTA.num_proc_hea,14)=CTM.num_proc_mea and CTA.cd_tp_tx=CTM.cd_tp_Tx and CTA.dc_hea<>CTM.dc_mea and CTA.cd_tp_moeda=CTM.cd_tp_moeda
	LEFT Join Caixa_MAS_exp_aer CXM on CTM.num_proc_mea=CXM.num_proc_mea and CTM.cd_tp_tx=CXM.cd_tp_tx and CTM.dc_mea=CXM.dc_mea and Convert(datetime,CXM.dt_pgto_rcto_mea,105) <=Convert(datetime,CXA.dt_pgto_rcto_hea,105) and CXM.num_lcto <> 'PROVISÓRIO'

WHERE
	cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime,CXA.dt_pgto_rcto_hea,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
	AND (CXO.Par_moeda_hea is not null or CXM.Par_moeda_mea is not null)		
	and cta.cd_tp_moeda <> 'REL'

UNION

select 
	cxa.num_proc_mea,Convert(datetime,CXA.dt_pgto_rcto_mea,105) DataPgto,Nome_tp_tx,CXA.DC_mea,CXA.vlr_ref_mea Vlr_Pgto,CXA.Par_moeda_mea ParCXA,CXM.Par_moeda_hea ParCXM, CXO.Par_moeda_mea ParCXO
from 
	caixA_mas_exp_aer cxa
	Join Cta_cte_mas_exp_aer CTA on CTA.num_proc_mea=CXA.num_proc_mea and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_mea=CXA.dc_mea
	Join Tipo_taxa TT on TT.cd_tp_tx=CXA.cd_tp_tx
	Left Join Cta_cte_mas_exp_aer CTO on CTA.num_proc_mea=CTO.num_proc_mea and CTA.cd_tp_tx=CTO.cd_tp_Tx and CTA.dc_mea<>CTO.dc_mea and CTA.cd_tp_moeda=CTO.cd_tp_moeda
	LEFT Join Caixa_mas_exp_aer CXO on CTO.num_proc_mea=CXO.num_proc_mea and CTO.cd_tp_tx=CXO.cd_tp_tx and CTO.dc_mea=CXO.dc_mea and Convert(datetime,CXO.dt_pgto_rcto_mea,105) <=Convert(datetime,CXA.dt_pgto_rcto_mea,105) and CXO.num_lcto <> 'PROVISÓRIO'
	Left Join Cta_cte_HOU_exp_aer CTM on CTA.num_proc_mea=LEFT(CTM.num_proc_hea,14) and CTA.cd_tp_tx=CTM.cd_tp_Tx and CTA.dc_mea<>CTM.dc_hea and CTA.cd_tp_moeda=CTM.cd_tp_moeda
	LEFT Join Caixa_HOU_exp_aer CXM on CTM.num_proc_hea=CXM.num_proc_hea and CTM.cd_tp_tx=CXM.cd_tp_tx and CTM.dc_hea=CXM.dc_hea and Convert(datetime,CXM.dt_pgto_rcto_hea,105) <=Convert(datetime,CXA.dt_pgto_rcto_mea,105) and CXM.num_lcto <> 'PROVISÓRIO'

WHERE
	cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime,CXA.dt_pgto_rcto_MEA,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
	AND (CXO.Par_moeda_mea is not null or CXM.Par_moeda_hea is not null)	
	and cta.cd_tp_moeda <> 'REL'

union all

--Importação Maritima
select 
	cxa.num_proc_HIM,Convert(datetime,CXA.dt_pgto_rcto_HIM,105) DataPgto,Nome_tp_tx,CXA.DC_HIM,CXA.vlr_ref_HIM Vlr_Pgto,CXA.Par_moeda_HIM ParCXA,CXM.Par_moeda_MIM ParCXM, CXO.Par_moeda_HIM ParCXO
from 
	caixA_hou_imp_MAR cxa
	Join Cta_cte_hou_imp_MAR CTA on CTA.num_proc_HIM=CXA.num_proc_HIM and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_HIM=CXA.dc_HIM
	Join Tipo_taxa TT on TT.cd_tp_tx=CXA.cd_tp_tx
	Left Join Cta_cte_hou_imp_MAR CTO on CTA.num_proc_HIM=CTO.num_proc_HIM and CTA.cd_tp_tx=CTO.cd_tp_Tx and CTA.dc_HIM<>CTO.dc_HIM and CTA.cd_tp_moeda=CTO.cd_tp_moeda
	LEFT Join Caixa_hou_imp_MAR CXO on CTO.num_proc_HIM=CXO.num_proc_HIM and CTO.cd_tp_tx=CXO.cd_tp_tx and CTO.dc_HIM=CXO.dc_HIM and Convert(datetime,CXO.dt_pgto_rcto_HIM,105) <=Convert(datetime,CXA.dt_pgto_rcto_HIM,105) and CXO.num_lcto <> 'PROVISÓRIO'
	Left Join Cta_cte_MAS_imp_MAR CTM on LEFT(CTA.num_proc_HIM,14)=CTM.num_proc_MIM and CTA.cd_tp_tx=CTM.cd_tp_Tx and CTA.dc_HIM<>CTM.dc_MIM and CTA.cd_tp_moeda=CTM.cd_tp_moeda
	LEFT Join Caixa_MAS_imp_MAR CXM on CTM.num_proc_MIM=CXM.num_proc_MIM and CTM.cd_tp_tx=CXM.cd_tp_tx and CTM.dc_MIM=CXM.dc_MIM and Convert(datetime,CXM.dt_pgto_rcto_MIM,105) <=Convert(datetime,CXA.dt_pgto_rcto_HIM,105) and CXM.num_lcto <> 'PROVISÓRIO'
WHERE
	cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime,CXA.dt_pgto_rcto_him,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
	AND (CXO.Par_moeda_him is not null or CXM.Par_moeda_mim is not null)	
	and cta.cd_tp_moeda <> 'REL'

union

select 
	cxa.num_proc_MIM,Convert(datetime,CXA.dt_pgto_rcto_MIM,105) DataPgto,Nome_tp_tx,CXA.DC_MIM,CXA.vlr_ref_MIM Vlr_Pgto,CXA.Par_moeda_MIM ParCXA,CXM.Par_moeda_HIM ParCXM, CXO.Par_moeda_MIM ParCXO
from 
	caixA_mas_imp_MAR cxa
	Join Cta_cte_mas_imp_MAR CTA on CTA.num_proc_MIM=CXA.num_proc_MIM and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_MIM=CXA.dc_MIM
	Join Tipo_taxa TT on TT.cd_tp_tx=CXA.cd_tp_tx
	Left Join Cta_cte_mas_imp_MAR CTO on CTA.num_proc_MIM=CTO.num_proc_MIM and CTA.cd_tp_tx=CTO.cd_tp_Tx and CTA.dc_MIM<>CTO.dc_MIM and CTA.cd_tp_moeda=CTO.cd_tp_moeda
	LEFT Join Caixa_mas_imp_MAR CXO on CTO.num_proc_MIM=CXO.num_proc_MIM and CTO.cd_tp_tx=CXO.cd_tp_tx and CTO.dc_MIM=CXO.dc_MIM and Convert(datetime,CXO.dt_pgto_rcto_MIM,105) <=Convert(datetime,CXA.dt_pgto_rcto_MIM,105) and CXO.num_lcto <> 'PROVISÓRIO'
	Left Join Cta_cte_HOU_imp_MAR CTM on CTA.num_proc_MIM=LEFT(CTM.num_proc_HIM,14) and CTA.cd_tp_tx=CTM.cd_tp_Tx and CTA.dc_MIM<>CTM.dc_HIM and CTA.cd_tp_moeda=CTM.cd_tp_moeda
	LEFT Join Caixa_HOU_imp_MAR CXM on CTM.num_proc_HIM=CXM.num_proc_HIM and CTM.cd_tp_tx=CXM.cd_tp_tx and CTM.dc_HIM=CXM.dc_HIM and Convert(datetime,CXM.dt_pgto_rcto_HIM,105) <=Convert(datetime,CXA.dt_pgto_rcto_MIM,105) and CXM.num_lcto <> 'PROVISÓRIO'

WHERE
	cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime,CXA.dt_pgto_rcto_mim,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
	AND (CXO.Par_moeda_mim is not null or CXM.Par_moeda_him is not null)	
	and cta.cd_tp_moeda <> 'REL'

UNION ALL
--Exportação Maritima

select 
	cxa.num_proc_HEM,Convert(datetime,CXA.dt_pgto_rcto_HEM,105) DataPgto,Nome_tp_tx,CXA.DC_HEM,CXA.vlr_ref_HEM Vlr_Pgto,CXA.Par_moeda_HEM ParCXA,CXM.Par_moeda_MEM ParCXM, CXO.Par_moeda_HEM ParCXO
from 
	caixA_hou_exp_MAR cxa
	Join Cta_cte_hou_exp_MAR CTA on CTA.num_proc_HEM=CXA.num_proc_HEM and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_HEM=CXA.dc_HEM
	Join Tipo_taxa TT on TT.cd_tp_tx=CXA.cd_tp_tx
	Left Join Cta_cte_hou_exp_MAR CTO on CTA.num_proc_HEM=CTO.num_proc_HEM and CTA.cd_tp_tx=CTO.cd_tp_Tx and CTA.dc_HEM<>CTO.dc_HEM and CTA.cd_tp_moeda=CTO.cd_tp_moeda
	LEFT Join Caixa_hou_exp_MAR CXO on CTO.num_proc_HEM=CXO.num_proc_HEM and CTO.cd_tp_tx=CXO.cd_tp_tx and CTO.dc_HEM=CXO.dc_HEM and Convert(datetime,CXO.dt_pgto_rcto_HEM,105) <=Convert(datetime,CXA.dt_pgto_rcto_HEM,105) and CXO.num_lcto <> 'PROVISÓRIO'
	Left Join Cta_cte_MAS_exp_MAR CTM on LEFT(CTA.num_proc_HEM,14)=CTM.num_proc_MEM and CTA.cd_tp_tx=CTM.cd_tp_Tx and CTA.dc_HEM<>CTM.dc_MEM and CTA.cd_tp_moeda=CTM.cd_tp_moeda
	LEFT Join Caixa_MAS_exp_MAR CXM on CTM.num_proc_MEM=CXM.num_proc_MEM and CTM.cd_tp_tx=CXM.cd_tp_tx and CTM.dc_MEM=CXM.dc_MEM and Convert(datetime,CXM.dt_pgto_rcto_MEM,105) <=Convert(datetime,CXA.dt_pgto_rcto_HEM,105) and CXM.num_lcto <> 'PROVISÓRIO'

WHERE
	cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime,CXA.dt_pgto_rcto_hem,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)	
	AND (CXO.Par_moeda_hem is not null or CXM.Par_moeda_mem is not null)	
	and cta.cd_tp_moeda <> 'REL'

UNION

select 
	cxa.num_proc_MEM,Convert(datetime,CXA.dt_pgto_rcto_MEM,105) DataPgto,Nome_tp_tx,CXA.DC_MEM,CXA.vlr_ref_MEM Vlr_Pgto,CXA.Par_moeda_MEM ParCXA,CXM.Par_moeda_HEM ParCXM, CXO.Par_moeda_MEM ParCXO
from 
	caixA_mas_exp_MAR cxa
	Join Cta_cte_mas_exp_MAR CTA on CTA.num_proc_MEM=CXA.num_proc_MEM and CTA.cd_tp_tx=CXA.cd_tp_tx and CTA.dc_MEM=CXA.dc_MEM
	Join Tipo_taxa TT on TT.cd_tp_tx=CXA.cd_tp_tx
	Left Join Cta_cte_mas_exp_MAR CTO on CTA.num_proc_MEM=CTO.num_proc_MEM and CTA.cd_tp_tx=CTO.cd_tp_Tx and CTA.dc_MEM<>CTO.dc_MEM and CTA.cd_tp_moeda=CTO.cd_tp_moeda
	LEFT Join Caixa_mas_exp_MAR CXO on CTO.num_proc_MEM=CXO.num_proc_MEM and CTO.cd_tp_tx=CXO.cd_tp_tx and CTO.dc_MEM=CXO.dc_MEM and Convert(datetime,CXO.dt_pgto_rcto_MEM,105) <=Convert(datetime,CXA.dt_pgto_rcto_MEM,105) and CXO.num_lcto <> 'PROVISÓRIO'
	Left Join Cta_cte_HOU_exp_MAR CTM on CTA.num_proc_MEM=LEFT(CTM.num_proc_HEM,14) and CTA.cd_tp_tx=CTM.cd_tp_Tx and CTA.dc_MEM<>CTM.dc_HEM and CTA.cd_tp_moeda=CTM.cd_tp_moeda
	LEFT Join Caixa_HOU_exp_MAR CXM on CTM.num_proc_HEM=CXM.num_proc_HEM and CTM.cd_tp_tx=CXM.cd_tp_tx and CTM.dc_HEM=CXM.dc_HEM and Convert(datetime,CXM.dt_pgto_rcto_HEM,105) <=Convert(datetime,CXA.dt_pgto_rcto_MEM,105) and CXM.num_lcto <> 'PROVISÓRIO'
WHERE
	cxa.num_lcto <> 'PROVISÓRIO' and convert(datetime,CXA.dt_pgto_rcto_MEM,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
	AND (CXO.Par_moeda_mem is not null or CXM.Par_moeda_hem	 is not null)	
	and cta.cd_tp_moeda <> 'REL'

GO
