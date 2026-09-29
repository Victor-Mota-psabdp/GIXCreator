SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PO_HEO
CREATE procedure [dbo].[spATL_PO_HEO_Del]
(
	@Num_Proc_HEO	varChar(16),
	@ID_PO_HEO		int
)

as
	 if exists(select PO.Num_Proc_HEO from PO_HEO PO with(nolock) where PO.Num_Proc_HEO = @Num_Proc_HEO and PO.ID_PO_HEO = @ID_PO_HEO)
		Begin
			delete PO_HEO where Num_Proc_HEO = @Num_Proc_HEO and ID_PO_HEO = @ID_PO_HEO
		End

GO
