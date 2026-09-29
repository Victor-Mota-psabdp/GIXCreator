SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help AX_DOC_XML_New
--alter table [dbo].[AX_DOC_XML_New] add [Verificado] [bit] NULL
--alter table [dbo].[AX_DOC_XML_New] add [MessageId] Varchar(500) NULL
--alter table [dbo].[AX_DOC_XML_New] add Dt_Reenvio	datetime NULL
--alter table [dbo].[AX_DOC_XML_New] add [ErrorMessage] Varchar(5000) NULL
CREATE Procedure [dbo].[spATL_AX_DOC_XML_New_Upd]
(
	@ID_AX				bigint,
	@Num_Proc			Varchar(16),	
	@Cd_tp_Tx_ATL		varchar(10),
	@DC					varchar(1),	
	@MessageId			Varchar(500),
	@Verificado			bit,
	@Dt_Reenvio			Datetime,
	@ErrorMessage		Varchar(5000)

)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help AX_DOC_XML_New
	BEGIN TRY
			
		if exists(select ID_AX from AX_DOC_XML_New where ID_AX=@ID_AX and Num_Proc = @Num_Proc and Cd_tp_Tx_ATL = @Cd_tp_Tx_ATL and DC = @DC)
			BEGIN
				Update
					AX_DOC_XML_New
				set					
					MessageId = @MessageId,
					Verificado = @Verificado,
					Dt_Reenvio = @Dt_Reenvio,
					ErrorMessage = @ErrorMessage
				where
					ID_AX=@ID_AX and Num_Proc = @Num_Proc and Cd_tp_Tx_ATL = @Cd_tp_Tx_ATL and DC = @DC
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
