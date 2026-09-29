SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alter table [dbo].AX_Master_XML add Dt_Reenvio	datetime NULL
CREATE Procedure [dbo].[spATL_AX_Master_XML_InsUpd]
(
	@ID_AX				bigint,
	@Num_Proc			Varchar(16),	
	@Cd_Tp_Instrucao	varchar(1),
	@Dt_Envio			Datetime,		
	@XML_DOC			XML,
	@Nome_Arquivo		Varchar(100),
	@MessageId			Varchar(500),
	@Verificado			bit,
	@Dt_Reenvio			Datetime

)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help AX_Master_XML
	BEGIN TRY
			
		if exists(select ID_AX from AX_Master_XML where Num_Proc = @Num_Proc and ID_AX=@ID_AX)
			BEGIN
				Update
					AX_Master_XML
				set
					--ID_AX=@ID_AX,
					--Tipo = @Cd_Tp_Instrucao,
					--Dt_Envio = @Dt_Envio,
					--XML_DOC = @XML_DOC,
					--Nome_Arquivo = @Nome_Arquivo,
					--MessageId = @MessageId,
					Verificado = @Verificado,
					Dt_Reenvio= @Dt_Reenvio
				where
					Num_Proc = @Num_Proc and ID_AX=@ID_AX
			End
		Else	
			BEGIN
				set @ID_AX = (select isnull(MAX(ID_AX),0)+1 from AX_Master_XML)
				Insert AX_Master_XML 
				(
					ID_AX,Num_Proc,Tipo,Dt_Envio,XML_DOC,Nome_Arquivo,
					MessageId,Verificado,Dt_Reenvio
				)
				Values
				(
					@ID_AX,@Num_Proc,@Cd_Tp_Instrucao,@Dt_Envio,@XML_DOC,@Nome_Arquivo,
					@MessageId,@Verificado,@Dt_Reenvio
				)			
			END	
	
		Select @ID_AX as Retorno;		
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
