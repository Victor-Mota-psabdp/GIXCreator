SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spSaldoPedidoItemLote_Rel '618956','72635','P000015539','1','UN'
--27-07-2015 incluido o dt pedido nao ser null

CREATE Procedure [dbo].[spSaldoPedidoItemLote_Rel] --'0046001487', '000000000015075552','9519','00060' 

	@Num_Pedido VarChar(30),
	@cd_Proc_Cliente VarChar(30),
	@Consignee VarChar(50),
	@Shipper varchar(50),
	@Item	varchar(6),
	@Lote	varchar(30)

as	

	Declare @Cd_Shipper		varchar(10)
	Declare @Cd_Consignee	varchar(10)

Set @Cd_Shipper = (Select Cd_Pes from Pessoa with(nolock) where apelido = @Shipper)
Set @Cd_Consignee = (Select Cd_Pes from Pessoa  with(nolock) where apelido = @Consignee)

Declare @Cd_Pedido Int
Declare @cd_prod Int
Declare @Entradas float
Declare @Saida Float
Declare @Cd_Grupo varchar(10)

Set @Cd_Grupo =(select top 1 Cd_Grupo  from Pedido where num_pedido=@Num_Pedido and status<>'E' and (CD_SELLER=@Cd_Shipper or Cd_Shipper = @Cd_Shipper) and (CD_BUYER=@Cd_Consignee or CD_Consignee =@Cd_Consignee) and Dt_Pedido is not null)
Set @Cd_pedido=(select top 1 cd_pedido from pedido where num_pedido=@Num_Pedido and status<>'E' and (CD_SELLER=@Cd_Shipper or Cd_Shipper = @Cd_Shipper) and (CD_BUYER=@Cd_Consignee or CD_Consignee =@Cd_Consignee) and Dt_Pedido is not null)
Set @Cd_Prod=(select top 1 cd_prod from produto_cliente where cd_proc_cliente=@cd_proc_cliente and cd_cliente=@Cd_Grupo)

set @Entradas=isnull((select sum(qty) from pedido_det where item=@Item and cd_pedido=@cd_pedido and cd_produto=@cd_prod and Lote = @lote),0)
Set @Saida=isnull((select sum(qty) from pedido_ship where item=@Item and cd_pedido=@cd_pedido and cd_produto=@cd_prod and Lote = @lote),0)

Select (@Entradas - @Saida) Qty


GO
