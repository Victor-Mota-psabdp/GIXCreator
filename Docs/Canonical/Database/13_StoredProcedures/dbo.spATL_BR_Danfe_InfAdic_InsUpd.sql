SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_BR_Danfe_InfAdic_InsUpd]
(
	@Id_Danfe	int,
	@infAdFisco [varchar](2000),
	@infCpl		[varchar](2000)	
)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Danfe_InfAdic
	BEGIN TRY			
		if not exists(select id_danfe from ATL_BR.dbo.Danfe_InfAdic with(nolock) where id_danfe=@id_danfe)
			Begin									
				Insert into ATL_BR.dbo.Danfe_InfAdic
				(
					Id_Danfe,infAdFisco,infCpl
				)
				Values
				(
					@Id_Danfe,@infAdFisco,@infCpl
				)						
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.Danfe_InfAdic
				Set
					infAdFisco=@infAdFisco,
					infCpl=@infCpl
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
