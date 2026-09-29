SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PO_HIO
CREATE procedure [dbo].[spATL_PO_HIO_Del]
(
	@Num_Proc_HIO	varChar(16),
	@ID_PO_HIO	int
)

as
 if exists(select PO.Num_Proc_HIO from PO_HIO PO with(nolock) where PO.Num_Proc_HIO = @Num_Proc_HIO 
	and PO.ID_PO_HIO = @ID_PO_HIO)
	Begin
		delete PO_HIO where Num_Proc_HIO = @Num_Proc_HIO and ID_PO_HIO = @ID_PO_HIO
	End

GO
