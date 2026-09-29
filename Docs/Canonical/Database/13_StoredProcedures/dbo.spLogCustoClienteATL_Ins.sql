SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from custo_cliente
--select * from custo_cliente_arg

CREATE	Procedure [dbo].[spLogCustoClienteATL_Ins]
	
	@Cd_Usuario			varchar	(6),
	@Tp_Oper_CC			char	(1),
	@Num_Pedido			VarChar(30),
	@Prod_ID 			varchar(30),
	@Tipo_Taxa			Varchar(50),
	@Valor				float,
	@Cliente			Varchar(50),
	@Modal				varchar(16),
	@Prestacao			Char(1),
	@Processo			varchar(16),
	@Retencao			float,
	@Ganancias			float,
	@Tipo				char(1),
	@Tipo_Debito		char(1),
	@CUIT				varchar(12)

AS

BEGIN TRANSACTION

	Declare @Cd_Pedido	int
	Declare @Cd_Produto	int
	Declare @Cd_Tp_Tx 	varchar(30)
	Declare @Cd_Cliente	Varchar(10)
	--inclusão do @cd_pes_grupo para buscar o cd_produto correto
	Declare @cd_pes_grupo varchar(10)
		Set @cd_pes_grupo = (select top 1 cd_pes_grupo from grupo where grupo = right(left(@Processo,5),3))
		Set @Cd_Cliente = (Select top 1 Cd_pes from Pessoa where apelido = @Cliente)
		--Set @Cd_Pedido = (select Cd_Pedido from Pedido join pessoa pp on (CD_SELLER=@Cd_Cliente OR CD_BUYER=@CD_CLIENTE) where Num_Pedido=@Num_Pedido and apelido=@cliente and cd_modal=@Modal)
		Set @Cd_Pedido = (
				select top 1 PD.Cd_Pedido from Pedido PD
				Join Pedido_Ship PS on PS.cd_pedido=PD.cd_pedido	
				--join pessoa pp on (CD_SELLER=@Cd_Cliente OR CD_BUYER=@CD_CLIENTE or cd_consignee=@Cd_Cliente) 
				
				where Num_Pedido=@Num_Pedido  and num_proc=@Processo
				)
		Set @Cd_Produto = (select top 1 Cd_Prod from produto_cliente where cd_proc_Cliente=@Prod_ID and cd_cliente=@cd_pes_grupo)
		Set @Cd_Tp_Tx	= (Select top 1 Cd_Tp_Tx from Tipo_Taxa where Nome_tp_tx = @Tipo_Taxa)

	Insert into Log_CustoCliente
		(
		Data_CC,
		Cd_Usuario,
		Tp_Oper_CC,
		Num_Proc_CC,
		Cd_Pedido,
		Cd_Produto,
		Cd_Tp_Tx,
		Vlr_Item_Custo,		
		Prestacao,
		Retencao,
		Ganancias,
		Tipo,
		Tipo_Debito,
		CUIT
	)						
	Values
		(
		getDate(),
		@Cd_Usuario,
		@Tp_Oper_CC,
		@Processo,
		@Cd_Pedido,
		@Cd_Produto,
		@Cd_Tp_Tx,
		@Valor,		
		@Prestacao,
		@Retencao,
		@Ganancias,
		@Tipo,
		@Tipo_Debito,
		@CUIT	
		)	

	IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION
GO
