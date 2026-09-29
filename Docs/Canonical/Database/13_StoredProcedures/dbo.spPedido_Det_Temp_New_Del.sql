SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Pedido_Det_Temp_New 
CREATE Procedure [dbo].[spPedido_Det_Temp_New_Del] 
(	
	@ID					bigint
)
as

BEGIN TRANSACTION
	
	IF EXISTS(SELECT ID FROM Pedido_Det_Temp_New Where ID=@ID and cd_pedido is null)		
		BEGIN
			DELETE Pedido_Det_Temp_New Where ID=@ID AND cd_pedido IS NULL
		END
		
	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -2
		END

COMMIT TRANSACTION

GO
