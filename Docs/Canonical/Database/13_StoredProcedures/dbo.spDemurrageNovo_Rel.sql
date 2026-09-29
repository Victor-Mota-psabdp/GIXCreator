SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure spDemurrageNovo_Rel as


select 
	HOU.Num_proC_him Processo,Apelido,nome_tp_Cont, idm_per_fim,idm_per_inic,
	idm_tx,dt_vcto_devol_im,dt_devol_im,Num_Cont_IM,sum(dbo.valor(vlr_org_him, CTA.DC_HIM)) Valor
from 
	container_mas_imp_mar CM
	Join Container_hou_imp_mar CH on CH.num_proc_mim=CM.num_proc_mim and ch.item_cont_im=cm.item_cont_im
	Join House_imp_mar HOU on HOU.num_proc_him=CH.num_proc_him
	Join Pessoa PP on PP.cd_pes=cd_import_him
	Join Tipo_Container TC on TC.cd_tp_cont=CM.cd_tp_Cont
	Join Master_imp_mar mas on MAS.num_proc_mim=CM.num_proC_mim
	Left Join Item_Demurrage ITD on ITD.cd_Tp_cont=CM.cd_tp_cont and ITD.cd_armador='BDP' 
	Left Join cta_cte_hou_imp_mar CTA on CTA.num_proc_him=hou.num_proc_him and cd_cred_dev_him=cd_imporT_him and cd_tp_tx in ('DC2','DC3','DCT','DE2','DE3','DE4','DEM')	
where 
	cm.cd_tp_cont <> 'LCL'
	and convert(datetime,dt_atrac_mim,105) between '01-01-2006' and getdate()
	and convert(Datetime,dt_vcto_devol_im,105) <= getdate()
GROUP BY
	HOU.Num_proC_him,Apelido,nome_tp_Cont, idm_per_fim,
	idm_tx,dt_vcto_devol_im,dt_devol_im,Num_Cont_IM,ITD.Idm_Per_Inic






GO
