SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Function fBuscaPorcentagem_PedidoProdutoCusto
(
	@num_proc	varchar(16),
	@cd_pedido int,
	@cd_produto int
)
returns float

as

begin
Declare @Total as Float
Declare @QuantidadePedidoProduto as Float

Set @Total=(select sum(qty) from pedido_ship where num_proc=@num_proc)
Set @QuantidadePedidoProduto=(select sum(qty) from pedido_ship where num_proc=@num_proc and cd_pedido=@cd_pedido and cd_produto=@cd_produto)
Return @QuantidadePedidoProduto/@Total


end
GO
