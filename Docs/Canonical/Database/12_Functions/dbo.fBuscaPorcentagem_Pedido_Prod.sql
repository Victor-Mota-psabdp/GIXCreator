SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--select 

CREATE function [dbo].[fBuscaPorcentagem_Pedido_Prod] 
(
	@Num_Proc Char(16),
	@Cd_Pedido int,
	@Cd_Produto int
)

returns	Float

AS
	Begin
		Declare @qtyPedido as Float
		Declare @qtyTotal as Float

		Set @qtyPedido=(
						select sum(ps.qty) from pedido_ship ps with(nolock)
						Where Cd_pedido=@Cd_pedido and cd_produto=@Cd_Produto and num_proc=@num_proc
						)

		set @qtyTotal= (
						select sum(ps.qty) from pedido_ship ps with(nolock)
						Where cd_produto=@Cd_Produto and num_proc=@num_proc
						)

--		Return (@qtypedido/@qtytotal)

		if ((@qtypedido = 0) or (@qtytotal = 0))
			Begin
				Return 0
			End

--			Begin
				Return (@qtypedido/@qtytotal)
--			End

	END

GO
