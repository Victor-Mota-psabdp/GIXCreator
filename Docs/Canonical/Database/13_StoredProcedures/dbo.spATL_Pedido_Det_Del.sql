SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Pedido_Det_Del]
(
	@Cd_Pedido			int,
	@Cd_Produto			int,
	@Lote				varchar(30),
	@Item				varchar(4)
)
as

IF EXISTS(SELECT CD_PEDIDO FROM Pedido_Det Where cd_pedido=@cd_pedido and item=@item and lote=@lote and Cd_Produto=@Cd_Produto)
	BEGIN
		Delete Pedido_Det Where cd_pedido=@cd_pedido and item=@item and lote=@lote and Cd_Produto=@Cd_Produto
	END

GO
