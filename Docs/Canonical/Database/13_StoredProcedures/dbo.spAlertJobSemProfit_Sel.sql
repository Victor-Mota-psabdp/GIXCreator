SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--29-05 incluido pra nao trazer qdo estiver preenchido - 38 - processo sem profit

CREATE Procedure [dbo].[spAlertJobSemProfit_Sel]

as

select 
	Hou.Num_Proc_Him,convert(varchar(10),eta_lim,103) ETA,PP.apelido Agent,CS.Apelido Cliente,HAWB_HIM,MAWB_HIM 
from 
	house_imp_mar Hou
	Left Join cta_cte_hou_imp_mar CTA on CTa.num_proc_him=hou.num_proc_him and cd_tp_Tx  in (select cd_Tp_Tx from tipo_Taxa where pft_Aer='S')
	Join LLP_Imp_Mar LLP on llp.num_proC_lim=hou.num_proc_him
	Join Master_Imp_Mar MAS on MAS.num_proc_mim=hou.num_proC_mim
	Join Pessoa PP on PP.cd_pes=cd_export_mim
	Join Pessoa CS on CS.cd_pes=cd_consig_him
	left join Hist_Geral HG with(nolock) on HG.HSGProcesso=HOU.Num_Proc_Him and HG.cd_tp_ocor = '38'
Where
	hou.Num_Proc_MIM <> 'JOB' and
	CTA.Num_Proc_Him is null
	and hou.num_proc_mim not like '%CLI%'
	and hou.num_proc_him not like '%REM%'
	and hou.num_proc_him not like '%WAL%'
	and HG.cd_tp_ocor is null

Union all


select 
	Hou.Num_Proc_Hia,convert(varchar(10),eta_lia,103) ETA,PP.apelido Agent,CS.Apelido Cliente,HAWB_HIA,MAWB_HIA 
from 
	house_imp_Aer Hou
	Left Join cta_cte_hou_imp_aer CTA on CTa.num_proc_hia=hou.num_proc_hia and cd_tp_Tx  in (select cd_Tp_Tx from tipo_Taxa where pft_Aer='S')
	Join LLP_Imp_Aer LLP on llp.num_proC_lia=hou.num_proc_hia
	Join Master_Imp_Aer MAS on MAS.num_proc_mia=hou.num_proC_mia
	Join Pessoa PP on PP.cd_pes=cd_export_mia
	Join Pessoa CS on CS.cd_pes=cd_consig_hia	
	left join Hist_Geral HG with(nolock) on HG.HSGProcesso=HOU.Num_Proc_Hia and HG.cd_tp_ocor = '38'
Where
	hou.Num_Proc_MIA <> 'JOB' and
	CTA.Num_Proc_HiA is null
	and hou.num_proc_miA not like '%CLI%'
	and hou.num_proc_hiA not like '%REM%'
	and hou.num_proc_hia not like '%WAL%'
	and HG.cd_tp_ocor is null

Union all

select 
	Hou.Num_Proc_HEm,convert(varchar(10),etd_lem,103) ETA,PP.apelido Agent,CS.Apelido Cliente,HAWB_HEM,MAWB_HEM 
from 
	house_exp_mar Hou
	Left Join cta_cte_hou_exp_mar CTA on CTa.num_proc_hem=hou.num_proc_hem and cd_tp_Tx  in (select cd_Tp_Tx from tipo_Taxa where pft_Aer='S')
	Join LLP_exp_Mar LLP on llp.num_proC_lem=hou.num_proc_hem
	Join Master_exp_Mar MAS on MAS.num_proc_mem=hou.num_proC_mem
	Join Pessoa PP on PP.cd_pes=cd_Consig_mem
	Join Pessoa CS on CS.cd_pes=cd_export_hem
	left join Hist_Geral HG with(nolock) on HG.HSGProcesso=HOU.Num_Proc_Hem and HG.cd_tp_ocor = '38'
Where
	hou.Num_Proc_MEM <> 'JOB' and
	CTA.Num_Proc_Hem is null
	and hou.num_proc_mem not like '%CLI%'
	and hou.num_proc_hem not like '%REM%'
	and hou.num_proc_hem not like '%WAL%'
	and HG.cd_tp_ocor is null


Union all


select 
	Hou.Num_Proc_HEA,convert(varchar(10),etd_lea,103) ETA,PP.apelido Agent,CS.Apelido Cliente,HAWB_HEA,MAWB_HEA 
from 
	house_exp_Aer Hou
	Left Join cta_cte_hou_exp_aer CTA on CTa.num_proc_hea=hou.num_proc_hea and cd_tp_Tx  in (select cd_Tp_Tx from tipo_Taxa where pft_Aer='S')
	Join LLP_exp_aer LLP on llp.num_proC_lea=hou.num_proc_hea
	Join Master_exp_aer MAS on MAS.num_proc_mea=hou.num_proC_mea
	Join Pessoa PP on PP.cd_pes=cd_Consig_mea
	Join Pessoa CS on CS.cd_pes=cd_export_hea
	left join Hist_Geral HG with(nolock) on HG.HSGProcesso=HOU.Num_Proc_Hea and HG.cd_tp_ocor = '38'
Where
	hou.Num_Proc_MEA <> 'JOB' and
	CTA.Num_Proc_Hea is null
	and hou.num_proc_mea not like '%CLI%'
	and hou.num_proc_hea not like '%REM%'
	and hou.num_proc_hea not like '%WAL%'
	and HG.cd_tp_ocor is null

GO
