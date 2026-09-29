SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spDemurrage_ContainerDT_Sel]
	@Processo	varchar(16),
	@num_cont_im varchar(15)
As
	select IsNull(dt_devol_im,'') Data ,Nome_Tp_Cont 
	from container_mas_imp_mar MAS 
	Join Container_Hou_Imp_Mar HOU on MAS.Num_Proc_MIM = HOU.Num_Proc_MIM and MAS.Item_Cont_IM = HOU.Item_Cont_IM   
	Join Tipo_Container TC on TC.cd_tp_cont=MAS.cd_tp_cont 
	where HOU.num_proc_him=@Processo
	and num_cont_im=@num_cont_im

Union ALL 

select IsNull(dt_devol_im,'') Data ,Nome_Tp_Cont 
	from container_mas_imp_mar MAS 
	Join Tipo_Container TC on TC.cd_tp_cont=MAS.cd_tp_cont 
	where num_proc_mim=@Processo and num_cont_im=@num_cont_im



GO
