SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Custo_Cliente
CREATE Procedure [dbo].[spATL_Custo_Cliente_InsUpd]
(
	@Num_Proc		Varchar(16),
	@Cd_Pedido		int,
	@Cd_Produto		int,
	@Cd_tp_tx		varchar(3),
	@Vlr_Item_Custo	decimal(10,2),
	@Num_NF_Custo	Varchar(20),
	@Prestacao		Char(1)
)

AS

	if not exists(select num_proc from custo_cliente where num_proc=@num_proc and cd_pedido=@cd_pedido and cd_produto=@cd_produto and cd_tp_Tx=@Cd_Tp_Tx)
		Begin			
			Insert into	Custo_Cliente
			(
				Num_Proc,Cd_Pedido,Cd_Produto,Cd_tp_tx,Vlr_Item_Custo,Num_NF_Custo,Prestacao
			)
			Values
			(
				@Num_Proc,@Cd_Pedido,@Cd_Produto,@Cd_tp_tx,@Vlr_Item_Custo,@Num_NF_Custo,@Prestacao
			)

			End
		else
			Begin			
				Update 
					Custo_Cliente
				Set
					Vlr_Item_Custo=@Vlr_Item_Custo,
					Prestacao=@Prestacao
				Where
					Num_Proc=@Num_Proc and Cd_Pedido=@Cd_Pedido 
					and Cd_Produto=@cd_produto and cd_Tp_tx=@cd_tp_Tx
			End


GO
