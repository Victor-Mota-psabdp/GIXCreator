SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[spATL_VerificaOrdem_Sel]
(
	@Num_Pedido VarChar(30),
	@Consignee varchar(50),
	@Shipper varchar(50)
)
as
Select num_pedido from pedido PO with(nolock)
Join Pessoa Seller with(nolock) on Seller.cd_pes=Cd_Seller
Join Pessoa Buyer with(nolock) on  Buyer.cd_pes=cd_buyer
Left Join Pessoa Consignee with(nolock) on Consignee.cd_pes = cd_Consignee
Left Join Pessoa Shipper with(nolock) on Shipper.cd_pes = Cd_Shipper
where num_pedido = @Num_Pedido
and (seller.apelido = @Shipper or Shipper.apelido = @Shipper)
and (buyer.apelido=@Consignee or Consignee.apelido=@Consignee)
GO
