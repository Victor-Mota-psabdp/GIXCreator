SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure spPedidoDup_Del
		@cd_pedido	int

as

BEGIN transaction
	if not exists(select cd_pedido from pedido_ship where cd_pedido=@cd_pedido)
		BEGIN
			DELETE FROM DATA_PEDIDOS WHERE CD_PEDIDO=@CD_PEDIDO
			DELETE FROM PEDIDO_DET	WHERE CD_PEDIDO=@CD_PEDIDO
			DELETE FROM HIST_GERAL WHERE HSGPROCESSO=cast(@CD_PEDIDO as varchar)
			DELETE FROM PEDIDO WHERE CD_PEDIDO=@CD_PEDIDO
		
		END
	if @@error <> 0
		BEGIN
			rollback transaction
			return -1
		end
commit transaction




GO
