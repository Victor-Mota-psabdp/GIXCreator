SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_BR_Danfe_Transp_InsUpd]
(
	@Id_Danfe	int,
	@modFrete	int,
	@CNPJ	varchar(14),
	@xNome	varchar(60),
	@xEnder	varchar	(60),
	@xMun	varchar	(60),
	@UF	char (2)
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Transp
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Transp with(nolock) where id_danfe=@id_danfe)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Transp
				(
					Id_Danfe,modFrete,CNPJ,xNome,xEnder,xMun,UF
				)
				Values
				(
					@Id_Danfe,@modFrete,@CNPJ,@xNome,@xEnder,@xMun,@UF
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Transp
				Set
					modFrete=@modFrete,
					CNPJ=@CNPJ,
					xNome=@xNome,
					xEnder=@xEnder,
					xMun=@xMun,
					UF=@UF
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
