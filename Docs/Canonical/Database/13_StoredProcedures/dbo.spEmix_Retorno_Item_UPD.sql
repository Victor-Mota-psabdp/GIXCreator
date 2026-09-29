SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spEmix_Retorno_Item_UPD]
	@ID			bigint,
	@ID_Item	int,
	@Campo		Varchar(40),
	@TIPO		VARCHAR(25)

AS

	Begin Transaction	
	
	IF @TIPO = 'Emix_Cria_Zip'
		BEGIN
			update 
				ATL_INT.dbo.Emix_Retorno_Item 
			set 
				Dt_Create_ZIP = getdate()
			where 
				ID = @ID and ID_item = @ID_Item and Campo = @Campo		
		END
		
	IF @TIPO = 'FILEtoPDF2ATL'
		BEGIN			
			update 
				ATL_INT.dbo.Emix_Retorno_Item 
			set
				Dt_SendToPDF2ATL = getdate() 
			where 
				ID = @ID and ID_item = @ID_Item and Campo = @Campo			
		END			
		

	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
Commit Transaction


GO
