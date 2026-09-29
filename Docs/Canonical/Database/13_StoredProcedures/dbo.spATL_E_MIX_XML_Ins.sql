SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_E_MIX_XML_Ins]
(
	@ID					bigint,
	@Num_Proc			Varchar(16),	
	@Id_Consulta_Tipo	int,
	@Dt_Envio			Datetime,
	@Envio_Erro			Varchar(400),	
	@XML_DOC			XML,
	@Nome_Arquivo		Varchar(100),
	@XML_DOC2			XML,
	@Dt_Retorno			Datetime,
	@Retorno_Erro		Varchar(400)
)

AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help E_MIX_XML
	BEGIN TRY
		
		BEGIN
			Insert E_MIX_XML 
			(
				ID,Num_Proc,id_consulta_tipo,Dt_Envio,Envio_Erro,XML_DOC,Nome_Arquivo,
				XML_DOC2,Dt_Retorno,Retorno_Erro
			)
			Values
			(
				@ID,@Num_Proc,@id_consulta_tipo,@Dt_Envio,@Envio_Erro,@XML_DOC,@Nome_Arquivo,
				@XML_DOC2,@Dt_Retorno,@Retorno_Erro
			)
			
		END	
	
		Select @ID as Retorno;		
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
