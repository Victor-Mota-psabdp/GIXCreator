SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure spProcSemFatura 

		@DataFinal	Varchar (10)

AS

Select 
	cast(Apelido as Char(20)) Cliente,hou.Num_proc_hia,dt_cheg_mia,CTA.cd_Tp_moeda,cta.dc_hia,sum(vlr_org_hia) Valor
From 
	House_Imp_Aer HOU
	Join cta_cte_hou_imp_aer CTA on CTA.num_proc_hia=hou.num_proc_hia and CTA.cd_cred_dev_hia=HOU.cd_Consig_hia and desp_org_hia='N' and cta.dc_hia='C' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	Join Pessoa PP on PP.cd_pes=cd_import_hia
	Join Master_Imp_Aer MAS on MAS.num_proc_mia=HOU.num_proc_mia
	Left Join Item_Fat ITF on ITF.num_proc=CTA.num_proc_hia and ITF.cd_tp_tx=CTA.cd_tp_tx and DC=cta.dc_hia
	Left Join Fatura FAT on ITF.fatcod=FAT.fatcod and fatstatus=1
	Left Join Caixa_hou_Imp_Aer CXA on CTA.num_proc_hia=CXA.num_proc_hia and CTA.dc_hia=CXA.dc_hia and CTA.cd_tp_tx=CXA.cd_tp_Tx and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hia,105) <=@DataFinal
Where 
	ITF.fatcod is null and CXA.num_lcto is null and left(hou.num_proc_hia,5) <> 'IAJOB'

Group by
	Apelido,hou.Num_proc_hia,dt_cheg_mia,CTA.cd_Tp_moeda,cta.dc_hia

UNION

Select 
	cast(Apelido as Char(20)) Cliente,hou.Num_proc_him,dt_atrac_mim,CTA.cd_Tp_moeda,cta.dc_him,sum(vlr_org_him) Valor
From 
	House_Imp_mar HOU
	Join cta_cte_hou_imp_mar CTA on CTA.num_proc_him=hou.num_proc_him and CTA.cd_cred_dev_him=HOU.cd_Consig_him and desp_org_him='N' and cta.dc_him='C' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	Join Pessoa PP on PP.cd_pes=cd_import_him
	Join Master_Imp_mar MAS on MAS.num_proc_mim=HOU.num_proc_mim
	Left Join Item_Fat ITF on ITF.num_proc=CTA.num_proc_him and ITF.cd_tp_tx=CTA.cd_tp_tx and DC=cta.dc_him
	Left Join Fatura FAT on ITF.fatcod=FAT.fatcod and fatstatus=1
	Left Join Caixa_hou_Imp_mar CXA on CTA.num_proc_him=CXA.num_proc_him and CTA.dc_him=CXA.dc_him and CTA.cd_tp_tx=CXA.cd_tp_Tx and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_him,105) <=@DataFinal
Where 
	ITF.fatcod is null and CXA.num_lcto is null and left(hou.num_proc_him,5) <> 'IMJOB'

Group by
	Apelido,hou.Num_proc_him,dt_atrac_mim,CTA.cd_Tp_moeda,cta.dc_him

UNION

Select 
	cast(Apelido as Char(20)) Cliente,hou.Num_proc_hea,dt_saida_mea,CTA.cd_Tp_moeda,cta.dc_hea,sum(vlr_org_hea) Valor
From 
	House_exp_Aer HOU
	Join cta_cte_hou_exp_aer CTA on CTA.num_proc_hea=hou.num_proc_hea and CTA.cd_cred_dev_hea=HOU.cd_Consig_hea and desp_DST_hea='N' and cta.dc_hea='C' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	Join Pessoa PP on PP.cd_pes=cd_export_hea
	Join Master_exp_Aer MAS on MAS.num_proc_mea=HOU.num_proc_mea
	Left Join Item_Fat ITF on ITF.num_proc=CTA.num_proc_hea and ITF.cd_tp_tx=CTA.cd_tp_tx and DC=cta.dc_hea
	Left Join Fatura FAT on ITF.fatcod=FAT.fatcod and fatstatus=1
	Left Join Caixa_hou_exp_Aer CXA on CTA.num_proc_hea=CXA.num_proc_hea and CTA.dc_hea=CXA.dc_hea and CTA.cd_tp_tx=CXA.cd_tp_Tx and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hea,105) <=@DataFinal
Where 
	ITF.fatcod is null and CXA.num_lcto is null and left(hou.num_proc_hea,5) <> 'IAJOB'

Group by
	Apelido,hou.Num_proc_hea,dt_saida_mea,CTA.cd_Tp_moeda,cta.dc_hea

UNION

Select 
	cast(Apelido as Char(20)) Cliente,hou.Num_proc_hem,dt_SAIDA_mem,CTA.cd_Tp_moeda,cta.dc_hem,sum(vlr_org_hem) Valor
From 
	House_exp_mar HOU
	Join cta_cte_hou_exp_mar CTA on CTA.num_proc_hem=hou.num_proc_hem and CTA.cd_cred_dev_hem=HOU.cd_Consig_hem and desp_DST_hem='N' and cta.dc_hem='C' and cta.cd_tp_tx not in (select * from param_aekcontabil_taxas_exc)
	Join Pessoa PP on PP.cd_pes=cd_export_hem
	Join Master_exp_mar MAS on MAS.num_proc_mem=HOU.num_proc_mem
	Left Join Item_Fat ITF on ITF.num_proc=CTA.num_proc_hem and ITF.cd_tp_tx=CTA.cd_tp_tx and DC=cta.dc_hem
	Left Join Fatura FAT on ITF.fatcod=FAT.fatcod and fatstatus=1
	Left Join Caixa_hou_exp_mar CXA on CTA.num_proc_hem=CXA.num_proc_hem and CTA.dc_hem=CXA.dc_hem and CTA.cd_tp_tx=CXA.cd_tp_Tx and num_lcto <> 'PROVISÓRIO' and convert(datetime,dt_pgto_rcto_hem,105) <=@DataFinal
Where 
	ITF.fatcod is null and CXA.num_lcto is null and left(hou.num_proc_hem,5) <> 'IMJOB'

Group by
	Apelido,hou.Num_proc_hem,dt_SAIDA_mem,CTA.cd_Tp_moeda,cta.dc_hem


GO
