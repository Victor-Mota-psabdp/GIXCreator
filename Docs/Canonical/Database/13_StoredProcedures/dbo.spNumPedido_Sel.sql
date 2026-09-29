SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spNumPedido_Sel] --'ELETRONICA SELENIUM', 'HARMAN SAN DIEGO'

	@Shipper	Varchar(50),
	@Consignee	Varchar(50)

AS
select 
	UPPER(num_pedido) Num_Pedido
from 
	pedido PO with(nolock)
	Join Pessoa Seller with(nolock) on Seller.cd_pes=Cd_Seller
	Join Pessoa Buyer with(nolock) on  Buyer.cd_pes=cd_buyer
	Left Join Pessoa Consignee with(nolock)  on Consignee.cd_pes = cd_Consignee
	Left Join Pessoa Shipper with(nolock)  on Shipper.cd_pes = PO.Cd_Shipper
where 
	(seller.apelido = @Shipper or Shipper.Apelido = @Shipper)  and (buyer.apelido= @Consignee or Consignee.apelido=@Consignee) and dt_pedido > getdate() -360
Group by Num_Pedido, dt_pedido
Order by dt_pedido desc
GO
