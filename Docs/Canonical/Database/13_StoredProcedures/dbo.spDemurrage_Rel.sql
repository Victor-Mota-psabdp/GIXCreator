SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spDemurrage_Rel]

AS

select 

	apelido,num_cont_im,hawb_him,mawb_him,navio_mim,dt_oper_mim,
	free_time,dt_devol_im 

from 
	house_imp_mar HOU

	Join pessoa PP on PP.cd_pes=cd_Consig_him
	Join container_hou_imp_mar CH on HOU.num_proc_him=CH.num_proc_him
	Join master_imp_mar mas on mas.num_proc_mim=hou.num_proc_mim
	Join container_mas_imp_mar cm on cm.num_proc_mim=ch.num_proc_mim and cm.item_cont_im=ch.item_cont_im 
	Left Outer Join Demurrage dem on mas.cd_armador=dem.cd_armador and cm.cd_tp_cont=dem.cd_tp_cont

where 
	cm.cd_tp_cont <> 'LCL' and
	convert(datetime,dt_atrac_mim,105) >convert(datetime,'01/01/2005',105)





GO
