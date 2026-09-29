SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_BR_Danfe_Exporta_InsUpd]
(
	@Id_Danfe	int,
	@UFSaidaPais [varchar](5),
	@xLocExporta [varchar](250),
	@xLocDespacho [varchar](5)
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_Exporta
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_Exporta with(nolock) where id_danfe=@id_danfe)
			Begin									
				Insert into ATL_BR.dbo.Danfe_Exporta
				(
					Id_Danfe,UFSaidaPais,xLocExporta,xLocDespacho
				)
				Values
				(
					@Id_Danfe,@UFSaidaPais,@xLocExporta,@xLocDespacho
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_Exporta
				Set
					UFSaidaPais=@UFSaidaPais,
					xLocExporta=@xLocExporta,
					xLocDespacho=@xLocDespacho
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
