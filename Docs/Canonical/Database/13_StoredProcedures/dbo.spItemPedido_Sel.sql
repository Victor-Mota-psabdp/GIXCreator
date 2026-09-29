SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spItemPedido_Sel]

	@NumPedido varchar(30),
	@CdProdCliente varchar(30),
	@Shipper	Varchar(50),
	@Consignee	Varchar(50)

AS
/* Alterado por Erbson - 21-04-2013: Verifica Seller e Buyer */
--27-07-2015 incluido o dt pedido nao ser null

	Declare @Cd_Shipper		varchar(10)
	Declare @Cd_Consignee	varchar(10)

Set @Cd_Shipper = (Select Cd_Pes from Pessoa with(nolock) where apelido = @Shipper)
Set @Cd_Consignee = (Select Cd_Pes from Pessoa  with(nolock) where apelido = @Consignee)

select 
	Item 
from 
	pedido_det PD with(nolock) 
	Join Pedido P with(nolock) on PD.cd_pedido=P.cd_pedido 
	Join Produto_cliente PC with(nolock) on Pd.cd_produto = PC.cd_prod
Where 
	P.num_pedido= @NumPedido 
	and PC.Cd_Proc_Cliente = @CdProdCliente 
	and (P.Cd_Seller = @Cd_Shipper or P.Cd_Shipper = @Cd_Shipper)
	and (P.cd_Buyer= @Cd_Consignee or P.Cd_Consignee=@Cd_Consignee)
	and Dt_Pedido is not null
Group by 
	Item
Order by 
	Item




GO
