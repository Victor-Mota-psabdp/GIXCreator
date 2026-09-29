SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select [dbo].[spBuscaPorcentagem_Pedido]('IMCSR201201180BR','0001','18260110')


--select  [dbo].[spBuscaPorcentagem_Pedido] ('IMFMC201112041BR','000005','0046004016')


CREATE function [dbo].[spBuscaPorcentagem_Pedido] --('IMFMC201112041BR','000005','0046004016')
			(
			@Num_Proc Char(16),
			@Item	Varchar(10),
			@Num_Pedido Varchar(30)



)

returns
	float
as
	Begin
		Declare @codProduto float
		Declare @qtyPedido as Float
		Declare @qtyTotal as Float
		

		set @codproduto = (
								select cd_produto from pedido_ship PDD 
								Join Pedido PD on PD.cd_pedido=PDD.cd_pedido
								Where
									num_pedido=@num_pedido and item=@item and num_proc=@num_proc
							)

		Set @qtypedido=(
						select sum(ps.qty) from pedido_ship ps
						Join Pedido PD on PD.cd_pedido=Ps.cd_pedido
						Where
							cd_produto=@codproduto 
							and item=@item and num_proc=@num_proc and num_pedido=@num_pedido
						)
		set @qtytotal= (
						select sum(ps.qty) from pedido_ship ps
						Join Pedido PD on PD.cd_pedido=Ps.cd_pedido
						Where
							cd_produto=@codproduto 
							and num_proc=@num_proc
							and  num_pedido=@num_pedido
					)

		
		Return (@qtypedido/@qtytotal)
		








		END

























GO
