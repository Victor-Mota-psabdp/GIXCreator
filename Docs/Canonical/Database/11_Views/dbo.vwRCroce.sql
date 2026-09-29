SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE    view vwRCroce
as


/*
Select 
	Apelido,cta.num_proc_hia Processo,dbo.spresultado_mas(cta.num_proc_hia) Mas_Valor, cta.dc_hia,isnull(Vlr_Pgto_rcto_hia,vlr_org_hia*isnull(dbo.verparidade(dt_ins_hia,cta.cd_tp_moeda,'IMM'),1)) Valor
 from 
	house_imp_aer HOU
	Join Master_imp_aer mas on mas.num_proc_mia=hou.num_proc_mia
	Join Cta_Cte_Hou_Imp_aer Cta on cta.num_proc_hia=hou.num_proC_hia
	Left Join Caixa_hou_imp_aer cxa on cta.num_proc_hia=cxa.num_proc_hia and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hia=cxa.dc_hia and num_lcto <> 'PROVISÓRIO' 
	Join Pessoa PP on pp.cd_pes=cd_import_hia
Where 
	convert(datetime,dt_cheg_mia,105)>='01-01-2006'
	and cta.cd_Tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_Tx not in ('DBU','DC2','dc3','DC4','DC5','DCT','DD2','DDG','DE2','DE3','DE4','DE5','DEM','DV2','DVG')
	and cta.desp_org_hia='N'

*/


/**
Select 
	Apelido,cta.num_proc_him,dbo.spresultado_mas(cta.num_proc_him) Mas_Valor, cta.dc_him,isnull(Vlr_Pgto_rcto_him,vlr_org_him*isnull(dbo.verparidade(dt_ins_him,cta.cd_tp_moeda,'IMM'),1)) Valor
 from 
	house_imp_mar HOU
	Join Master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
	Join Cta_Cte_Hou_Imp_Mar Cta on cta.num_proc_him=hou.num_proC_him
	Left Join Caixa_hou_imp_mar cxa on cta.num_proc_him=cxa.num_proc_him and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_him=cxa.dc_him and num_lcto <> 'PROVISÓRIO' 
	Join Pessoa PP on pp.cd_pes=cd_import_him
Where 
	convert(datetime,dt_atrac_mim,105)>='01-01-2006'
	and cta.cd_Tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_Tx not in ('DBU','DC2','dc3','DC4','DC5','DCT','DD2','DDG','DE2','DE3','DE4','DE5','DEM','DV2','DVG')
	and cta.desp_org_him='N'
**/
/**
Select 
	Apelido,cta.num_proc_hea Processo,dbo.spresultado_mas(cta.num_proc_hea) Mas_Valor, cta.dc_hea DC_hia,isnull(Vlr_Pgto_rcto_hea,vlr_org_hea*isnull(dbo.verparidade(dt_ins_hea,cta.cd_tp_moeda,'IMM'),1)) Valor
 from 
	house_exp_aer HOU
	Join Master_exp_aer mas on mas.num_proc_mea=hou.num_proc_mea
	Join Cta_Cte_Hou_exp_aer Cta on cta.num_proc_hea=hou.num_proC_hea
	Left Join Caixa_hou_exp_aer cxa on cta.num_proc_hea=cxa.num_proc_hea and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hea=cxa.dc_hea and num_lcto <> 'PROVISÓRIO' 
	Join Pessoa PP on pp.cd_pes=cd_export_hea
Where 
	convert(datetime,dt_saida_mea,105)>='01-01-2006'
	and cta.cd_Tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_Tx not in ('DBU','DC2','dc3','DC4','DC5','DCT','DD2','DDG','DE2','DE3','DE4','DE5','DEM','DV2','DVG')
	and cta.desp_Dst_hea='N'
**/

Select 
	Apelido,cta.num_proc_hem Processo,dbo.spresultado_mas(cta.num_proc_hem) Mas_Valor, cta.dc_hem DC_hia,isnull(Vlr_Pgto_rcto_hem,vlr_org_hem*isnull(dbo.verparidade(dt_ins_hem,cta.cd_tp_moeda,'IMM'),1)) Valor
 from 
	house_exp_mar HOU
	Join Master_exp_mar mas on mas.num_proc_mem=hou.num_proc_mem
	Join Cta_Cte_Hou_exp_mar Cta on cta.num_proc_hem=hou.num_proC_hem
	Left Join Caixa_hou_exp_mar cxa on cta.num_proc_hem=cxa.num_proc_hem and cta.cd_tp_Tx=cxa.cd_tp_tx and cta.dc_hem=cxa.dc_hem and num_lcto <> 'PROVISÓRIO' 
	Join Pessoa PP on pp.cd_pes=cd_export_hem
Where 
	convert(datetime,dt_saida_mem,105)>='01-01-2006'
	and cta.cd_Tp_tx not in (select * from param_aekcontabil_taxas_exc)
	and cta.cd_tp_Tx not in ('DBU','DC2','dc3','DC4','DC5','DCT','DD2','DDG','DE2','DE3','DE4','DE5','DEM','DV2','DVG')
	and cta.desp_Dst_hem='N'




GO
