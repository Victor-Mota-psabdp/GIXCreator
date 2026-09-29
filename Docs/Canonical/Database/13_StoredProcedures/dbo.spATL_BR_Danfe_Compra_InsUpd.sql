SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_BR_Danfe_Compra_InsUpd]
(
	@Id_Danfe	int,
	@xPed [varchar](50)
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Compra
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Compra with(nolock) where id_danfe=@id_danfe)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Compra
				(
					Id_Danfe,xPed
				)
				Values
				(
					@Id_Danfe,@xPed
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Compra
				Set
					xPed=@xPed
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
