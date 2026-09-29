SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PO_HBO
CREATE procedure [dbo].[spATL_PO_HBO_Del]
(
	@Num_Proc_HBO	varChar(16),
	@ID_PO_HBO		int
)

as
	 if exists(select PO.Num_Proc_HBO from PO_HBO PO with(nolock) where PO.Num_Proc_HBO = @Num_Proc_HBO and PO.ID_PO_HBO = @ID_PO_HBO)
		Begin
			delete PO_HBO where Num_Proc_HBO = @Num_Proc_HBO and ID_PO_HBO = @ID_PO_HBO
		End


GO
