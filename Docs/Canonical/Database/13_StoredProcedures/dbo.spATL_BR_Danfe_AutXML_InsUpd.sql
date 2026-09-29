SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_BR_Danfe_AutXML_InsUpd]
(
	@Id_Danfe	int,
	@CNPJ	varchar(14)
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_AutXML
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_AutXML with(nolock) where id_danfe=@id_danfe)
			Begin									
				Insert into ATL_BR.dbo.Danfe_AutXML
				(
					Id_Danfe,CNPJ
				)
				Values
				(
					@Id_Danfe,@CNPJ
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_AutXML
				Set					
					CNPJ=@CNPJ					
				Where
					Id_Danfe=@Id_Danfe
			END		
			
		Select @Id_Danfe as Retorno;

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
