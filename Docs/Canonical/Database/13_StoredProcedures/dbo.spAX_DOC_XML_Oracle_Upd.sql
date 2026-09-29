SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[spAX_DOC_XML_Oracle_Upd]
(
	@ID_AX				bigint,
	@Cancel				bit,
	@MessageId			Varchar(500),
	@Verificado			bit,
	@Dt_Reenvio			Datetime,
	@ErrorMessage		Varchar(5000)
)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help AX_DOC_XML_Oracle
	BEGIN TRY
			
		if exists(select ID_AX from AX_DOC_XML_Oracle where ID_AX=@ID_AX and Cancel = @Cancel)
			BEGIN
				Update
					AX_DOC_XML_Oracle
				set					
					MessageId = @MessageId,
					Verificado = @Verificado,
					Dt_Reenvio = @Dt_Reenvio,
					ErrorMessage = @ErrorMessage
				where
					ID_AX=@ID_AX and Cancel = @Cancel
			End	
	
		Select @ID_AX as Retorno;		
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
