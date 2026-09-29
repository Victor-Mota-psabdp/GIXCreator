SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spPedido_Incoterm_Sel] --'4001106319-1','THE DOW CHEM 0001428','DOW BRASIL S 1413588'
	@Num_Pedido varchar(30),
	@Shipper	Varchar(50),
	@Consignee	Varchar(50)

AS
select 
	IC.Nome_Tp_Oper
from 
	pedido PO with(nolock)
	Join Pessoa Seller with(nolock) on Seller.cd_pes=Cd_Seller
	Join Pessoa Buyer with(nolock) on  Buyer.cd_pes=cd_buyer
	Left Join Pessoa Consignee with(nolock)  on Consignee.cd_pes = cd_Consignee
	join Tipo_Oper IC with(nolock) on PO.Incoterm = IC.Cd_Tp_Oper
	join InsertJOB_Order_Fields IOF with(nolock) on IOF.Cd_Pes_Grupo = PO.Cd_Grupo 
where 
	PO.Num_Pedido = @Num_Pedido and seller.apelido = @Shipper 
	and (buyer.apelido= @Consignee or Consignee.apelido=@Consignee) 
	and dt_pedido > getdate() -360
	and IOF.Incoterm = 1
	and IOF.Status = 1
GO
