SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PO_HIM
CREATE procedure [dbo].[spATL_PO_HIM_Del]
(
	@Num_Proc_HIM	varChar(16),
	@ID_PO_HIM	int
)

as
 if exists(select PO.Num_Proc_HIM from PO_HIM PO with(nolock) where PO.Num_Proc_HIM = @Num_Proc_HIM 
	and PO.ID_PO_HIM = @ID_PO_HIM)
	Begin
		delete PO_HIM where Num_Proc_HIM = @Num_Proc_HIM and ID_PO_HIM = @ID_PO_HIM
	End

GO
