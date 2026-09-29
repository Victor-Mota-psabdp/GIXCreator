SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_AjustePedido_Upd 'EMCSR201711127BR','30889957','99040779',24720.000,24720.000,24720.000,'KG',0.375000



CREATE procedure spATL_AjustePedido_Upd
(
	@BDPRef varchar(16),
	@SalesOrder varchar(100),
	@ProductID varchar(100),
	@GrossWeight float,
	@Netweight float,
	@Qty float,
	@UoM varchar(100),
	@UnitPrice float

)
as

Declare @QtyPedido int
Declare @Cd_Pedido varchar(100)
Declare @Cd_Produto varchar(100)

Declare @Vlr float

select @QtyPedido = COUNT(Num_Proc)  from dbo.vwPedidoShipxPedido
where Num_Pedido = @SalesOrder and Cd_Grupo = '1' group by Num_Proc
print @QtyPedido
if @QtyPedido = 1
	Begin
	
	select @Cd_Pedido = cd_pedido, @Cd_Produto = v.cd_produto  from dbo.vwPedidoShipxPedido v
	join Produto_Cliente P on v.cd_produto = P.cd_prod and P.cd_Cliente = '1' 
	where Num_proc = @BDPRef and  Num_Pedido = @SalesOrder and P.cd_Proc_Cliente = @ProductID and Cd_Grupo = '1' 
	
	update Pedido_Det set Peso_Bruto_TOT =@GrossWeight , Peso_Liquido_TOT = @Netweight , Qty = @Qty, UOM = @UoM, Vlr_Item = @UnitPrice, Vlr_Total_Item = cast((@Qty * @UnitPrice) as decimal(18,6))
	where Cd_Pedido = @Cd_Pedido and Cd_Produto = @Cd_Produto
	
	update Pedido_Ship set Qty = @Qty
	where Num_Proc = @BDPRef and Cd_Pedido =  @Cd_Pedido and Cd_Produto = @Cd_Produto
	
	select @Vlr = SUM(Vlr_Total_Item) from Pedido_Det where Cd_Pedido = @Cd_Pedido 
	
	update Pedido set vlr_pedido = @Vlr where Cd_Pedido = @Cd_Pedido 
	
	
	
	
	End

GO
