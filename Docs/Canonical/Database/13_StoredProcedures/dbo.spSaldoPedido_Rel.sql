SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE       Procedure [dbo].[spSaldoPedido_Rel] --'4147006838', '41905100'

	@Num_Pedido VarChar(30),
	@cd_Proc_Cliente VarChar(30),
	@cd_Shipper varchar(10)

as	

Declare @Cd_Pedido Int
Declare @cd_prod Int
Declare @Entradas float
Declare @Saida Float
Declare @Cd_Grupo varchar(10)

Set @Cd_Grupo =(select top 1 Cd_Grupo  from Pedido where num_pedido=@Num_Pedido and status<>'E' and Cd_Seller=@cd_Shipper)
Set @Cd_pedido=(select top 1 cd_pedido from pedido where num_pedido=@Num_Pedido and status<>'E' and Cd_Seller=@cd_Shipper)
Set @Cd_Prod=(select top 1 cd_prod from produto_cliente where cd_proc_cliente=@cd_proc_cliente and cd_cliente=@Cd_Grupo)

set @Entradas=isnull((select sum(qty) from pedido_det where cd_pedido=@cd_pedido and cd_produto=@cd_prod),0)
Set @Saida=isnull((select sum(qty) from pedido_ship where cd_pedido=@cd_pedido and cd_produto=@cd_prod),0)

Select (@Entradas - @Saida) Qty

GO
