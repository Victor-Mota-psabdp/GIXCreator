SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spPedidoShip_Sel]
		@Cd_Pedido Int
as

select 
	cd_proc_cliente Cod_Cliene,Produto_Descr,Qty,Num_Proc, item 
from 
	pedido_ship PS
	Join Produto_Cliente PC on PC.cd_prod=PS.cd_produto
Where
	cd_pedido=@cd_pedido
order by
	item




GO
