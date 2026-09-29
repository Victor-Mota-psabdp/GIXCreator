SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Cta_Cte_Task_Del]
(
    @ID           bigint,
	@Ativo        int
)


AS
BEGIN
--Exceção(try/CATCH)
Begin Tran 
--Transação
	BEGIN TRY
			Begin
				Update Cta_Cte_Task set ativo = @ativo 
				Where ID = @ID
			End
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;
	END CATCH	
END

GO
