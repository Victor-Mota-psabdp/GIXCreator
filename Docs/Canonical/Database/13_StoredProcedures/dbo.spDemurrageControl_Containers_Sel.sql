SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   Procedure [dbo].[spDemurrageControl_Containers_Sel]
	@Num_Proc Char(16)

as
	select 
		Num_cont_im 
	from container_hou_imp_mar CH With(nolock) 
		Join Container_mas_imp_mar CM With(nolock) on CM.num_proc_mim=CH.num_proc_mim and CM.item_cont_im=CH.Item_cont_im 
	Where 
		cd_tp_cont not in ('LCL','LCM') and num_proc_him=@Num_Proc

GO
