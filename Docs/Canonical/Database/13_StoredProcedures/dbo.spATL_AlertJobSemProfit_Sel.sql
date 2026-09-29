SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--29-05 incluido pra nao trazer qdo estiver preenchido - 38 - processo sem profit
--10-12-13 incluido pra não trazer os casos 9- cancelados

CREATE Procedure [dbo].[spATL_AlertJobSemProfit_Sel]
	@all varchar(3)

as

select 
	Hou.Num_Proc_Him,
convert(varchar(10),eta_lim,103) ETA,PP.apelido Agent,CS.Apelido Cliente,HOU.HAWB_HIM,HOU.MAWB_HIM,CSR.Nome_Usuario [CSR Name]
from 
	house_imp_mar Hou With(nolock)
	Left Join cta_cte_hou_imp_mar CTA With(nolock) on CTa.num_proc_him=hou.num_proc_him and cd_tp_Tx  in (select cd_Tp_Tx from tipo_Taxa With(nolock) where pft_Aer='S')
	Join LLP_Imp_Mar			  LLP With(nolock) on llp.num_proC_lim=hou.num_proc_him
	Left Join Job_Imp_Mar		  JOB With(nolock) on HOU.Num_Proc_HIM = JOB.Num_Proc_HIM
	Join Master_Imp_Mar			  MAS With(nolock) on MAS.num_proc_mim=hou.num_proC_mim
	Join Pessoa					  PP  With(nolock) on PP.cd_pes=cd_export_mim
	Join Pessoa					  CS  With(nolock) on CS.cd_pes=cd_consig_him
	Left Join Usuario			  CSR with(nolock) on JOB.Cd_Usuario = CSR.Cd_Usuario
	left join Hist_Geral		  HG  with(nolock) on HG.HSGProcesso = HOU.Num_Proc_Him and HG.cd_tp_ocor = '38'
Where
	hou.Num_Proc_MIM <> 'JOB' and
	CTA.Num_Proc_Him is null
	and hou.num_proc_mim not like '%CLI%'
	and hou.num_proc_him not like '%REM%'
	and hou.num_proc_him not like '%WAL%'
	and HG.cd_tp_ocor is null
	and eta_lim <=getdate()-2
	and isnull(llp.id_status,0) <> '9'
	
Union all

select 
	Hou.Num_Proc_Hia,convert(varchar(10),eta_lia,103) ETA,PP.apelido Agent,CS.Apelido Cliente,HOU.HAWB_HIA,HOU.MAWB_HIA,CSR.Nome_Usuario [CSR Name]
from 
	house_imp_Aer Hou With(nolock)
	Left Join cta_cte_hou_imp_aer CTA With(nolock) on CTa.num_proc_hia=hou.num_proc_hia and cd_tp_Tx  in (select cd_Tp_Tx from tipo_Taxa With(nolock) where pft_Aer='S')
	Join LLP_Imp_Aer			  LLP With(nolock) on llp.num_proC_lia=hou.num_proc_hia
	Join Job_Imp_Aer			  JOB With(nolock) on HOU.Num_Proc_HIA = JOB.Num_Proc_HIA
	Join Master_Imp_Aer			  MAS With(nolock) on MAS.num_proc_mia=hou.num_proC_mia
	Join Pessoa					  PP  With(nolock) on PP.cd_pes=cd_export_mia
	Join Pessoa					  CS  With(nolock) on CS.cd_pes=cd_consig_hia
	Left Join Usuario			  CSR with(nolock) on JOB.Cd_Usuario = CSR.Cd_Usuario	
	left join Hist_Geral		  HG  with(nolock) on HG.HSGProcesso=HOU.Num_Proc_Hia and HG.cd_tp_ocor = '38'
	
Where
	hou.Num_Proc_MIA <> 'JOB' and
	CTA.Num_Proc_HiA is null
	and hou.num_proc_miA not like '%CLI%'
	and hou.num_proc_hiA not like '%REM%'
	and hou.num_proc_hia not like '%WAL%'
	and HG.cd_tp_ocor is null
	and eta_lia <=getdate()-2
	and isnull(llp.id_status,0) <> '9' 
	
Union all

select 
	Hou.Num_Proc_HEm,convert(varchar(10),etd_lem,103) ETA,PP.apelido Agent,CS.Apelido Cliente,HOU.HAWB_HEM,HOU.MAWB_HEM,CSR.Nome_Usuario [CSR Name] 
from 
	house_exp_mar Hou With(nolock)
	Left Join cta_cte_hou_exp_mar CTA With(nolock) on CTa.num_proc_hem=hou.num_proc_hem and cd_tp_Tx  in (select cd_Tp_Tx from tipo_Taxa With(nolock) where pft_Aer='S')
	Join LLP_exp_Mar			  LLP With(nolock) on llp.num_proC_lem=hou.num_proc_hem
	Join Job_Exp_Mar			  JOB With(nolock) on HOU.Num_Proc_HEM = JOB.Num_Proc_HEM
	Join Master_exp_Mar			  MAS With(nolock) on MAS.num_proc_mem=hou.num_proC_mem
	Join Pessoa					  PP  With(nolock) on PP.cd_pes=cd_Consig_mem
	Join Pessoa					  CS  With(nolock) on CS.cd_pes=cd_export_hem
	Left Join Usuario			  CSR with(nolock) on JOB.Cd_Usuario = CSR.Cd_Usuario
	left join Hist_Geral		  HG  with(nolock) on HG.HSGProcesso=HOU.Num_Proc_Hem and HG.cd_tp_ocor = '38'
Where
	hou.Num_Proc_MEM <> 'JOB' and
	CTA.Num_Proc_Hem is null
	and hou.num_proc_mem not like '%CLI%'
	and hou.num_proc_hem not like '%REM%'
	and hou.num_proc_hem not like '%WAL%'
	and HG.cd_tp_ocor is null
	and etd_lem <=getdate()-2
	and isnull(llp.id_status,0) <> '9' 

Union all


select 
	Hou.Num_Proc_HEA,convert(varchar(10),etd_lea,103) ETA,PP.apelido Agent,CS.Apelido Cliente,HOU.HAWB_HEA,HOU.MAWB_HEA,CSR.Nome_Usuario [CSR Name] 
from 
	house_exp_Aer Hou With(nolock)
	Left Join cta_cte_hou_exp_aer CTA With(nolock) on CTa.num_proc_hea=hou.num_proc_hea and cd_tp_Tx  in (select cd_Tp_Tx from tipo_Taxa With(nolock) where pft_Aer='S')
	Join LLP_exp_aer			  LLP With(nolock) on llp.num_proC_lea=hou.num_proc_hea
	Join Job_Exp_Aer			  JOB With(nolock) on HOU.Num_Proc_HEA = JOB.Num_Proc_HEA
	Join Master_exp_aer			  MAS With(nolock) on MAS.num_proc_mea=hou.num_proC_mea
	Join Pessoa					  PP  With(nolock) on PP.cd_pes=cd_Consig_mea
	Join Pessoa					  CS  With(nolock) on CS.cd_pes=cd_export_hea
	Left Join Usuario			  CSR with(nolock) on JOB.Cd_Usuario = CSR.Cd_Usuario
	left join Hist_Geral		  HG  with(nolock) on HG.HSGProcesso=HOU.Num_Proc_Hea and HG.cd_tp_ocor = '38'
Where
	hou.Num_Proc_MEA <> 'JOB' and
	CTA.Num_Proc_Hea is null
	and hou.num_proc_mea not like '%CLI%'
	and hou.num_proc_hea not like '%REM%'
	and hou.num_proc_hea not like '%WAL%'
	and HG.cd_tp_ocor is null
	and etd_lea <=getdate()-2
	and isnull(llp.id_status,0) <> '9'
GO
