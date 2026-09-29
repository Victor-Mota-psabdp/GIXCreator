SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from  Emix_Retorno_Export
CREATE procedure [dbo].[spEMixRetorno_Export_Ins]
(
		@XML_Recebido Varchar(MAX),
		@Tipo_Consulta Varchar(50),
		@Num_Proc	Varchar(16),
		@ID_Envio	BigInt,
		@id bigint output
)
	

AS
BEGIN 
	BEGIN TRY
		Declare @ID_New as bigint;
		--sp_help Emix_Retorno_Export
		BEGIN TRAN		
			Insert ATL_INT.DBO.Emix_Retorno_Export
			(
				XML_Recebido,Tipo_Consulta,Num_Proc,ID_Envio
			)
			Values
			(
				@XML_Recebido,@Tipo_Consulta,@num_proc,@ID_Envio
			)
			
			set @ID = @@IDENTITY;
			Select @ID as Retorno;
		
		COMMIT TRAN
		
		
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END
GO
