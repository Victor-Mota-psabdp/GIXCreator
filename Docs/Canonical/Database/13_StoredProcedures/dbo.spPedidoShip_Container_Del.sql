SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Incluido o deletar Pedido_Ship_Container*/
CREATE Procedure [dbo].[spPedidoShip_Container_Del] 

	@Num_Pedido	VarChar(30),
	@Prod_ID 	varchar(30),
	@Cliente	Varchar(50),
	@Processo	varchar(16),
	@Item		varchar(10),
	@Lote		varchar(30)
AS

BEGIN TRANSACTION

	Declare @Cd_Pedido	int
	Declare @Cd_Produto	int
	Declare @Cd_Cliente	varchar(10)

--Selecionar o Grupo
	Declare @cd_pes_grupo varchar(10)
	Set @Cd_Cliente = (Select top 1 Cd_pes from Pessoa where apelido = @Cliente)
	Set @cd_pes_grupo = (select top 1 cd_pes_grupo from pessoa_llp where cd_pes = @Cd_Cliente )

	Set @Cd_Pedido = (select top 1 P.cd_pedido from pedido P join pedido_ship PS on PS.cd_pedido = P.cd_pedido where num_pedido = @Num_Pedido and num_proc = @Processo)
	Set @Cd_Produto = (select top 1 Cd_Prod from produto_cliente PC join Pedido_Ship PS on PS.Cd_Produto = PC.Cd_Prod where cd_proc_Cliente=@Prod_ID and num_proc = @Processo)

	--Pedido Ship Container
	IF EXISTS(SELECT CD_PEDIDO FROM PEDIDO_SHIP_Container where Lote = @lote and Item = @Item and Num_proc = @Processo and Cd_Pedido= @Cd_Pedido and cd_produto = @Cd_Produto)
		Begin
			DELETE Pedido_Ship_Container 
				where Lote = @lote 
				and Item = @Item 
				and Num_proc = @Processo 
				and Cd_Pedido= @Cd_Pedido 
				and cd_produto = @Cd_Produto
		End


	IF @@Error <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION

GO
