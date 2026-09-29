SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select item, lote, 
--	(select cd_proc_cliente from produto_cliente where cd_prod = PD.cd_produto) Prod_ID, 
--	(select produto_descr from produto_cliente where cd_prod = PD.cd_produto) Prod_Descr, 
--	PD.Qty from pedido_det PD
--	 where cd_pedido=(select top 1 cd_pedido from pedido where num_pedido='" & cmbOrder.Text & "' 
--	 and status<>'E' and Cd_Seller='" & Busca_Cd_Shipper(cmbShipper.Text) & "'
--incluido o dt pedido nao ser null
    
CREATE Procedure [dbo].[spAdd_ALL_Prods_PO_Sel] 

		@Num_Pedido 	VarChar(30),
		@Shipper		VarChar(50),
		@Consignee			VarChar(50)
		
as
Declare @Cd_Shipper		varchar(10)
Declare @Cd_Consignee	varchar(10)

Set @Cd_Shipper = (Select Cd_Pes from Pessoa with(nolock) where apelido = @Shipper)
Set @Cd_Consignee = (Select Cd_Pes from Pessoa  with(nolock) where apelido = @Consignee)

Select
	item, lote,Cd_Proc_Cliente [Prod_ID],produto_descr [Prod_Descr],PD.Qty
from
	pedido P with(nolock)
Join Pedido_Det			PD with(nolock) on P.Cd_Pedido=PD.Cd_Pedido
Join Produto_Cliente	PC with(nolock) on PC.Cd_Prod = PD.Cd_Produto and P.Cd_Grupo = PC.Cd_Cliente
where 
	P.Num_Pedido = @Num_Pedido 
	and P.Cd_Seller = @Cd_Shipper 
	and (P.cd_Buyer = @Cd_Consignee or P.Cd_Consignee=@Cd_Consignee)
	and status<>'E'
	and Dt_Pedido is not null
--group by 
--	cd_proc_cliente,item
order by
	cd_proc_cliente
GO
