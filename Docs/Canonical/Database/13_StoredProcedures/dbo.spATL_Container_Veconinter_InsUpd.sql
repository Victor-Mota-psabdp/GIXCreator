SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CReate Procedure [dbo].[spATL_Container_Veconinter_InsUpd]

@Num_Proc_HIM	VarChar(16),
@Num_Cont_IM	VarChar(15),
@Dt_Devol_IM	VarChar(10)

AS

BEGIN TRANSACTION

	Declare @Num_Proc_MIM as Varchar(16)
	set @Num_Proc_MIM = (select CM.Num_Proc_MIM from container_hou_imp_mar HOU
		join container_mas_imp_mar CM on cm.num_proc_MIM=hou.num_proc_MIM and cm.item_cont_IM=HOU.item_cont_IM
		Where num_proc_HIM=@Num_Proc_HIM and replace(Num_Cont_IM,'-','')=@Num_Cont_IM)

	if exists( select num_proc_HIM from container_hou_imp_mar HOU
		join container_mas_imp_mar CM on cm.num_proc_MIM=hou.num_proc_MIM and cm.item_cont_IM=HOU.item_cont_IM
		Where num_proc_HIM=@num_proc_HIM and replace(Num_Cont_IM,'-','')=@Num_Cont_IM
		)		
		BEGIN
			UPDATE 
				CONTAINER_MAS_IMP_MAR
					set
						Dt_Devol_IM = @Dt_Devol_IM
			WHERE
				Num_Proc_MIM = @Num_Proc_MIM and replace(Num_Cont_IM,'-','')=@Num_Cont_IM

		END


Commit Transaction 

						
						













GO
