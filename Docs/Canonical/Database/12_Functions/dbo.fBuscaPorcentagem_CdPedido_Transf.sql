SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[fBuscaPorcentagem_CdPedido_Transf] --('IMFMT20090600401','00020','0046000919')
(
	@Num_Proc Char(16),
	@Item	Varchar(10),
	@Cd_Pedido int
)

returns
	Float
as
	Begin
		Declare @codProduto float
		Declare @qtyPedido as Float
		Declare @qtyTotal as Float
		

		set @codproduto = (
								select top 1 cd_produto from pedido_ship  
--								Join Pedido PD on PD.cd_pedido=PDD.cd_pedido
								Where
									Cd_pedido=@Cd_pedido and item=@item and num_proc=@Num_Proc
							)

		Set @qtypedido=(
						select sum(ps.qty) from pedido_ship ps  with(nolock)
--						Join Pedido PD on PD.cd_pedido=Ps.cd_pedido
						Where
							Cd_pedido=@Cd_pedido
							and cd_produto=@codproduto 
							and item=@item and num_proc=@num_proc
						)
		set @qtytotal= (
						select sum(ps.qty) from pedido_ship ps  with(nolock)
--						Join Pedido PD on PD.cd_pedido=Ps.cd_pedido
						Where
							Cd_pedido=@Cd_pedido
							and cd_produto=@codproduto 
							and num_proc=@num_proc
					)

		if ((@qtypedido = 0) or (@qtytotal = 0))
			Begin
				Return 0
			End

--			Begin
				Return (@qtypedido/@qtytotal)

		








		END























GO
