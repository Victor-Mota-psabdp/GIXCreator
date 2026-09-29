SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spPedido_Det_Complementar_Del]

	@Cd_Pedido		Int,
	@Nome_Produto	VarChar(500),
	@Lote			VarChar(30),
	@Item			Varchar(6)

as

BEGIN TRANSACTION
	Declare @cd_produto Int
	Declare @cd_pes_grupo varchar(10)

	set @cd_pes_grupo=(select cd_grupo from pedido where cd_pedido=@cd_pedido)
	Set @Cd_Produto=(select cd_prod from produto_cliente where produto_descr=@nome_produto and cd_cliente=@cd_pes_grupo)

	Delete 
		Pedido_Det_Complementar 
	where cd_pedido=@cd_pedido and cd_produto=@cd_produto and Lote = @Lote and Item = @Item
COMMIT TRANSACTION					
							








GO
