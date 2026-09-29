SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PO_HIA
CREATE procedure [dbo].[spATL_PO_HIA_Del]
(
	@Num_Proc_HIA	varChar(16),
	@ID_PO_HIA	int
)

as
 if exists(select PO.Num_Proc_HIA from PO_HIA PO with(nolock) where PO.Num_Proc_HIA = @Num_Proc_HIA 
	and PO.ID_PO_HIA = @ID_PO_HIA)
	Begin
		delete PO_HIA where Num_Proc_HIA = @Num_Proc_HIA and ID_PO_HIA = @ID_PO_HIA
	End

GO
