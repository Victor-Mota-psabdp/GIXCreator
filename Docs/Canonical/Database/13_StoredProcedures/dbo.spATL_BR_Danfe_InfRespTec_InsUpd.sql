SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_BR_Danfe_InfRespTec_InsUpd]
(
	@Id_Danfe	int,
	@CNPJ		[varchar](50),
	@xContato	[varchar](250),
	@email		[varchar](50),
	@fone		[varchar](50)
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_InfRespTec
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_InfRespTec with(nolock) where id_danfe=@id_danfe)
			Begin									
				Insert into ATL_BR.dbo.Danfe_InfRespTec
				(
					Id_Danfe,CNPJ,xContato,email,fone
				)
				Values
				(
					@Id_Danfe,@CNPJ,@xContato,@email,@fone
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_InfRespTec
				Set
					CNPJ=@CNPJ,
					xContato=@xContato,
					email=@email,
					fone=@fone
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
