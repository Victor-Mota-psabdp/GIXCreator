SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Custo_Cliente
Create Procedure [dbo].[spLog_CustoCliente_InsUpd]
(
	@Num_Proc		Varchar(16),
	@Cd_Pedido		int,
	@Cd_Produto		int,
	@Cd_tp_tx		varchar(3),
	@Vlr_Item_Custo	decimal(10,2),
	@Num_NF_Custo	Varchar(20),
	@Prestacao		Char(1),

	@ID_Log			bigint,
	@Dt_Alter		Datetime,
	@Tp_Oper		varchar(1),
	@cd_usuario		Varchar(10)
)

AS
	
	Begin
		Insert into Log_CustoCliente
			(Data_CC,Cd_Usuario,Tp_Oper_CC,Num_Proc_CC,Cd_Pedido,Cd_Produto,Cd_Tp_Tx,Vlr_Item_Custo,Prestacao,
			Retencao,Ganancias,Tipo,Tipo_Debito,CUIT)						
		Values
			(getdate(),@cd_usuario,@Tp_Oper,@Num_Proc,@Cd_Pedido,@cd_produto, @cd_tp_Tx, @Vlr_Item_Custo, @Prestacao,
			Null,Null,Null,Null,Null)
	End

	


GO
