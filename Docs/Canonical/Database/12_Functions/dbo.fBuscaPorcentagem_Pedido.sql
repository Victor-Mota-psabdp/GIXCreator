SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fBuscaPorcentagem_Pedido] 
(
	@Num_Proc Char(16),
	@Cd_Pedido int
)

returns	Float

AS
	Begin
		Declare @qtyPedido as Float
		Declare @qtyTotal as Float

		Set @qtyPedido=(
						select sum(ps.qty) from pedido_ship ps with(nolock)
						Where Cd_pedido=@Cd_pedido and num_proc=@num_proc
						)

		set @qtyTotal= (
						select sum(ps.qty) from pedido_ship ps with(nolock)
						Where num_proc=@num_proc
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
