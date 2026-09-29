SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Pedido_Det_Temp_New 
CREATE Procedure [dbo].[spATLANTIS_Pedido_Det_Temp_New_Del]
(
		@ID					bigint)

as


BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help Pedido_Det_Temp_New
	BEGIN TRY
		IF EXISTS(SELECT ID FROM Pedido_Det_Temp_New Where ID=@ID and cd_pedido is null)		
			BEGIN
				DELETE Pedido_Det_Temp_New Where ID=@ID AND cd_pedido IS NULL
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
