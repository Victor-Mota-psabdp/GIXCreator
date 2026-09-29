SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --SELECT * FROM Pedido WHERE Dt_Pedido > GETDATE() - 120 AND sTATUS = 'O' ORDER BY Dt_Pedido
 --spAdd_ALL_Prods_PO_Sel '4003192419Teste', 'DOW CORNING  2143808', 'DOW - 1627C'
 --[spVerifica_Pedido_Valido_Sel] '4003192419Teste', 'DOW CORNING  2143808', 'DOW - 1627C','1','4003192419','2413973'
 --spVerifica_Pedido_Valido_Sel '6000025443teste','DOW CORNING  2143808','DOW - 1627C','1','6000025443','4021759'
 
 
 --spVerifica_Pedido_Valido_Sel '4501537654','GIVAUDAN SUISSE','GIVAUDAN - 637C','1','UN','2717001'
CREATE Procedure [dbo].[spVerifica_Pedido_Valido_Sel] 

		@Num_Pedido 		VarChar(30),
		@Shipper			VarChar(50),
		@Consignee			VarChar(50),
		@Item				VarChar(6),
		@Lote				VarChar(30),
		@Cd_Proc_Cliente	VarChar(30)
		
as


--select P.num_pedido,PC.Cd_Proc_Cliente,PD.Item,PD.Lote from pedido_det PD  
-- Join Pedido P on PD.cd_pedido=P.cd_pedido  
-- Join Produto_cliente PC on Pd.cd_produto = PC.cd_prod  
--Where 
--	P.num_pedido=@Num_Pedido
--	and PC.Cd_Proc_Cliente = @Cd_Proc_Cliente
--	and PD.Item = @Item
--	and PD.Lote =@Lote	


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
	and (P.Cd_Seller = @Cd_Shipper or P.Cd_Shipper = @Cd_Shipper)
	and (P.cd_Buyer = @Cd_Consignee or P.Cd_Consignee=@Cd_Consignee)
	and item = @Item
	and Cd_Proc_Cliente = @Cd_Proc_Cliente
	and pd.Lote = @Lote
	and status<>'E'
	and Dt_Pedido is not null
	
	
	--cd_pedido=@cd_pedido and cd_produto=@cd_produto and Lote = @Lote and Item = @Item

GO
