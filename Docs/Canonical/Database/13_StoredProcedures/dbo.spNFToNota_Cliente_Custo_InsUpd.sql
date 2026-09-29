SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spNFToNota_Cliente_Custo_InsUpd] --'IAFMC20091100101','21633035','17598','INC',1651.57,null,'N'
		@Num_Proc	 Varchar(16),
		@Cd_Pedido		int,
		@Cd_Produto		int,
		@Cd_tp_tx		varchar(3),
		@Vlr_Item_Custo	float,
		@Num_NF_Custo	Varchar(20),
		@Prestacao		Char(1),
		@cd_usuario		varchar(6)

AS
Declare @Tp_Oper char(1)

	if not exists(select num_proc from custo_cliente where num_proc=@num_proc and cd_pedido=@cd_pedido and cd_produto=@cd_produto and cd_tp_Tx=@Cd_Tp_Tx)
		Begin
			Set @Tp_Oper = 'I'
			Insert into
				Custo_Cliente
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
				Set @Tp_Oper = 'A'
				Update
					Custo_Cliente
						Set
							Vlr_Item_Custo=@Vlr_Item_Custo,
							Prestacao=@Prestacao
				Where
					Num_Proc=@Num_Proc and Cd_Pedido=@Cd_Pedido and Cd_Produto=@cd_produto and cd_Tp_tx=@cd_tp_Tx
			End
				
	--log Custo
	Begin
		Insert into Log_CustoCliente
			(Data_CC,Cd_Usuario,Tp_Oper_CC,Num_Proc_CC,Cd_Pedido,Cd_Produto,Cd_Tp_Tx,Vlr_Item_Custo,Prestacao,
			Retencao,Ganancias,Tipo,Tipo_Debito,CUIT)						
		Values
			(getdate(),@cd_usuario,@Tp_Oper,@Num_Proc,@Cd_Pedido,@cd_produto, @cd_tp_Tx, @Vlr_Item_Custo, @Prestacao,
			Null,Null,Null,Null,Null)
	End

GO
