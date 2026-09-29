SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTarAer_Del
(
@TAEID		int)
AS

	Begin Transaction 
	Delete
		Tax_Tar_Aer

	Where 
		TAEID = @TAEID



	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 

	Delete
		Tar_Tar_Aer

	Where 
		TAEID = @TAEID

	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -2
		End 


	Delete
		Tar_Aer

	Where 
		TAEID = @TAEID

	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -3
		End 
	Else
		Begin 
			Commit Transaction 
			Return 1 
		End

GO
