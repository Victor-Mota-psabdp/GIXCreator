SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido o vwCliente_House para achar o cd_pes_grupo 03/-4/2019

CREATE        Procedure [dbo].[spPedidoCusto_Del] 
	
	@Num_Pedido	VarChar(30),
	@Prod_ID 	varchar(30),
	@Tipo_Taxa 	Varchar(50),
	@Modal		Char(1),
	@Cliente	Varchar(50),
	@Processo	varchar(16)
AS

BEGIN TRANSACTION

Declare @Cd_Pedido	int
Declare @Cd_Produto	int
Declare @Cd_Tp_Tx 	varchar(30)
Declare @Cd_Cliente	Varchar(10)
--inclusão do @cd_pes_grupo para buscar o cd_produto correto
Declare @cd_pes_grupo varchar(10)
	--Set @cd_pes_grupo = (select top 1 cd_pes_grupo from grupo where grupo = right(left(@Processo,5),3))
	
	Set @cd_pes_grupo = (select L.Cd_Pes_Grupo from vwCliente_House H
		join Pessoa_LLP L on L.Cd_Pes = H.cd_cliente where Num_Proc = @Processo)
		
	Set @Cd_Cliente = (Select top 1 Cd_pes from Pessoa where apelido = @cliente)
	Set @Cd_Pedido = (select top 1 Ps.Cd_Pedido from Pedido P left outer join Pedido_Ship PS on P.cd_pedido = PS.cd_pedido where Num_Pedido=@Num_Pedido and num_proc = @Processo group by PS.cd_pedido)
	Set @Cd_Produto = (select top 1 Cd_Prod from produto_cliente where cd_proc_Cliente=@Prod_ID and cd_cliente=@cd_pes_grupo)
	Set @Cd_Tp_Tx	= (Select top 1 Cd_Tp_Tx from Tipo_Taxa where Nome_tp_tx = @Tipo_Taxa)


		delete Custo_cliente where Num_proc = @Processo and Cd_Pedido= @Cd_Pedido and cd_tp_tx=@cd_tp_tx and cd_produto = @Cd_Produto
		delete Custo_cliente_ARG where Num_proc = @Processo and Cd_Pedido= @Cd_Pedido and cd_tp_tx=@cd_tp_tx and cd_produto = @Cd_Produto
		

		IF @@Error <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RETURN -1
			END


COMMIT TRANSACTION




GO
