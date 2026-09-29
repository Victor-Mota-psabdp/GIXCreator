SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE    Procedure [dbo].[spPedidoShipProc_Sel] 
	@Processo VarChar(16)
as	

SELECT 
	P.Num_pedido, PC.Cd_Proc_Cliente, PC.Produto_Descr, PS.Qty, PS.Item, PS.Lote
FROM 
	Pedido_Ship PS With(nolock)
	Join Pedido P With(nolock) on P.Cd_pedido = PS.Cd_Pedido
	Join Produto_Cliente PC With(nolock) on PC.cd_prod=PS.cd_produto
where 
	Num_Proc=@Processo





GO
