SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pPO_Del 
(
@Num_Proc 		VarChar(16), 
@ID			Int 
)
AS
	Declare @Modal 	VarChar(2)
	Set @Modal = Left(@Num_Proc, 2)
	If @Modal = 'IA'
		Begin 	
			Delete
				PO_HIA
			Where
				ID_PO_HIA = @ID
			Return @@RowCount
		End
	If @Modal = 'IM'
		Begin 	
			Delete
				PO_HIM
			Where
				ID_PO_HIM = @ID
			Return @@RowCount
		End
	If @Modal = 'EA'
		Begin 	
			Delete
				PO_HEA
			Where
				ID_PO_HEA = @ID
			Return @@RowCount
		End
	If @Modal = 'EM'
		Begin 	
			Delete
				PO_HEM
			Where
				ID_PO_HEM = @ID
			Return @@RowCount
		End

GO
