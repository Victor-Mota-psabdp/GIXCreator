SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help E_AirFreight_XML
CREATE Procedure [dbo].[spATL_E_AirFreight_XML_InsUpd]
(
	@ID_AirFreight		bigint,	
	@Num_Proc			varchar(16),
	@HAWB_MAWB			varchar(50),
	@XML_DOC			nvarchar(MAX),
	@Nome_Arquivo		Varchar(100),	
	@Dt_Envio			Datetime,
	@Status_Envio		varchar(500),
	@XML_DOC_XML_Retorno xml,
	@Dt_Ins_Retorno		datetime,
	@XML_DOC_Retorno	varchar(MAX)
)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help E_AirFreight_XML

	BEGIN TRY

		BEGIN TRANSACTION;
	
		Declare @ID_New as bigint;
		
		IF @ID_AirFreight IS NULL
			BEGIN
				Insert E_AirFreight_XML 
				(
					Num_Proc,HAWB_MAWB,XML_DOC,Nome_Arquivo,Dt_Envio,Status_Envio,XML_DOC_XML_Retorno,Dt_Ins_Retorno,XML_DOC_Retorno
				)
				Values
				(
					@Num_Proc,@HAWB_MAWB,@XML_DOC,@Nome_Arquivo,@Dt_Envio,@Status_Envio,@XML_DOC_XML_Retorno,@Dt_Ins_Retorno,@XML_DOC_Retorno
				)	
				set @ID_New = @@IDENTITY;			
			END	
		ELSE
			BEGIN
				Update
					E_AirFreight_XML
				set					
					Dt_Envio = @Dt_Envio
				where 
					ID_AirFreight = @ID_AirFreight and 
					Num_Proc = @Num_Proc
				set @ID_New = @ID_AirFreight
			End	
		
		Select @ID_New as Retorno;		
		
		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT ERROR_MESSAGE() as Retorno;
	END CATCH	

END

GO
