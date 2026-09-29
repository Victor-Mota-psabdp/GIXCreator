SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_BR_procEventoNFeEventoInfEventoDetEvento_InsUpd]
(
	@Id			int,
	@descEvento	varchar(200),
	@nProt		varchar(100),
	@xJust		varchar(200),
	@xCorrecao	varchar(200),
	@xCondUso	varchar(200)

)
AS

BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help procEventoNFeEventoInfEventoDetEvento
	BEGIN TRY			
		if not exists(select Id from ATL_BR.dbo.procEventoNFeEventoInfEventoDetEvento where Id = @Id)	
			Begin								
				Insert into ATL_BR.dbo.procEventoNFeEventoInfEventoDetEvento
				(
					Id,descEvento,nProt,xJust,xCorrecao,xCondUso
				)
				Values
				(
					@Id,@descEvento,@nProt,@xJust,@xCorrecao,@xCondUso
				)
			End
		Else
			BEGIN
				Update
					ATL_BR.dbo.procEventoNFeEventoInfEventoDetEvento
				SET
					descEvento=@descEvento,		
					nProt = @nProt,
					xJust=@xJust,
					xCorrecao=@xCorrecao,
					xCondUso=@xCondUso					
				Where
					Id=@Id
			END		
			
		Select @Id as Retorno;

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;

	END CATCH	

END

GO
