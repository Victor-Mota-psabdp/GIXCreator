SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help PO_HEA
CREATE procedure [dbo].[spATL_PO_HEA_Del]
(
	@Num_Proc_HEA	varChar(16),
	@ID_PO_HEA		int
)

as
	 if exists(select PO.Num_Proc_HEA from PO_HEA PO with(nolock) where PO.Num_Proc_HEA = @Num_Proc_HEA 
			and PO.ID_PO_HEA = @ID_PO_HEA)
		Begin
			delete PO_HEA where Num_Proc_HEA = @Num_Proc_HEA and ID_PO_HEA = @ID_PO_HEA
		End

GO
