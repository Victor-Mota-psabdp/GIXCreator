SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pTarMar_Del
(
@TAMID		int)
AS

	Begin Transaction 
	Delete
		Tax_Tar_Mar

	Where 
		TAMID = @TAMID



	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -1 
		End 

	Delete
		Tar_Tar_Mar

	Where 
		TAMID = @TAMID

	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -2
		End 


	Delete
		Tar_Mar

	Where 
		TAMID = @TAMID

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
