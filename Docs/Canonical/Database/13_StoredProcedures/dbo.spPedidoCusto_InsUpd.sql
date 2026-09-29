SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--incluido o vwCliente_House para achar o cd_pes_grupo 03/-4/2019
CREATE   procedure [dbo].[spPedidoCusto_InsUpd] --'77406046','00040360','Fumigação','900','THE DOW CHEM 01001D6','O','S','IMCSR20080100301',null,null,null,null

	@Num_Pedido	VarChar(30),
	@Prod_ID 	varchar(30),
	@Tipo_Taxa 	Varchar(50),
	@Valor		float,
	@Cliente	Varchar(50),
	@Modal		varchar(16),
	@Prestacao	Char(1),
	@Processo	varchar(16),
	@Retencao	float,
	@Ganancias	float,
	@Tipo		char(1),
	@Tipo_Debito char(1),
	@CUIT		varchar(12)

AS

BEGIN TRANSACTION

Declare @Cd_Pedido	int
Declare @Cd_Produto	int
Declare @Cd_Tp_Tx 	varchar(30)
Declare @Cd_Cliente	Varchar(10)
--inclusão do @cd_pes_grupo para buscar o cd_produto correto
Declare @cd_pes_grupo varchar(10)
	--Set @cd_pes_grupo = (select cd_pes_grupo from grupo where grupo = right(left(@Processo,5),3))
	Set @cd_pes_grupo = (select L.Cd_Pes_Grupo from vwCliente_House H
		join Pessoa_LLP L on L.Cd_Pes = H.cd_cliente where Num_Proc = @Processo)
	Set @Cd_Cliente = (Select Cd_pes from Pessoa where apelido = @Cliente)
	--Set @Cd_Pedido = (select Cd_Pedido from Pedido join pessoa pp on (CD_SELLER=@Cd_Cliente OR CD_BUYER=@CD_CLIENTE) where Num_Pedido=@Num_Pedido and apelido=@cliente and cd_modal=@Modal)
	Set @Cd_Pedido = (
			select top 1 PD.Cd_Pedido from Pedido PD
			Join Pedido_Ship PS on PS.cd_pedido=PD.cd_pedido	
			--join pessoa pp on (CD_SELLER=@Cd_Cliente OR CD_BUYER=@CD_CLIENTE or cd_consignee=@Cd_Cliente)			
			where Num_Pedido=@Num_Pedido  and num_proc=@Processo
			)
	Set @Cd_Produto = (select Cd_Prod from produto_cliente where cd_proc_Cliente=@Prod_ID and cd_cliente=@cd_pes_grupo)
	Set @Cd_Tp_Tx	= (Select Cd_Tp_Tx from Tipo_Taxa where Nome_tp_tx = @Tipo_Taxa)

	IF EXISTS(SELECT Cd_Pedido FROM custo_cliente 
		Where cd_pedido=@cd_pedido and cd_produto=@cd_produto and Num_Proc=@Processo and cd_tp_tx=@cd_tp_tx)
		BEGIN
			UPDATE
				custo_cliente
			SET
				Vlr_Item_Custo = @Valor,
				Prestacao = @Prestacao
			WHERE
				Num_Proc = @Processo and cd_pedido = @Cd_Pedido and cd_produto = @Cd_Produto  and cd_tp_tx=@cd_tp_tx
		END
	ELSE
		BEGIN
			INSERT INTO
				Custo_Cliente
				(
					Cd_pedido,
					Cd_Produto,
					Cd_Tp_Tx,
					Vlr_Item_Custo,
					Prestacao,
					Num_Proc
				)
			VALUES
				(
					@Cd_Pedido,
					@Cd_Produto,
					@Cd_Tp_Tx,
					@Valor,
					@Prestacao,
					@Processo
				)
		END

	IF @Tipo is not null 
	BEGIN
		if EXISTS(SELECT Cd_Pedido FROM custo_cliente_ARG 
			Where cd_pedido=@cd_pedido and cd_produto=@cd_produto and Num_Proc=@Processo and cd_tp_tx=@cd_tp_tx)
			BEGIN
				UPDATE
					custo_cliente_ARG
				SET
					Retencao	=@Retencao,
					Ganancias	=@Ganancias,
					Tipo		=@Tipo,
					Tipo_Debito	=@Tipo_Debito,
					CUIT		=@CUIT
				WHERE
					Num_Proc = @Processo and cd_pedido = @Cd_Pedido and cd_produto = @Cd_Produto  and cd_tp_tx=@cd_tp_tx
			END
		ELSE
			BEGIN
				INSERT INTO
					Custo_Cliente_ARG
					(
						Num_Proc,
						Cd_Pedido,
						Cd_Produto,
						Cd_Tp_tx,
						Retencao,
						Ganancias,
						Tipo,
						Tipo_Debito,
						CUIT
					)
				VALUES
					(
						@Processo,
						@Cd_Pedido,
						@Cd_Produto,
						@Cd_Tp_Tx,
						@Retencao,
						@Ganancias,
						@Tipo,
						@Tipo_Debito,
						@CUIT
					)
			END
	END

	IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END

COMMIT TRANSACTION








GO
