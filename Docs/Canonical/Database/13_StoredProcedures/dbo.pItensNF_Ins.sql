SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pItensNF_Ins 
(
@StrMachine		VarChar(20), 
@NF			VarChar(6), 
@Site			Char(1)
)
AS
	Declare @Processo	 VarChar(16) 
	Declare @Ret_Profit	Decimal(10,2) 
	Declare @Ret_Paridade	Float 
	Declare @Ret_Total	Decimal(10,2) 	
	Begin Transaction 
	Delete Tmp_Itens_NF Where StrMachine =  @StrMachine 
	If @@Error <> 0
		Begin 
			Return -10 
			RollBack Transaction 
		End 

	Declare CurItens Cursor For 
	Select 
		Num_Proc
	From 
		Tmp_Pre_Itens_NF 
	Where	
		Cd_Tp_Tx = 'FRT' and Left(Num_Proc, 1) = 'E' and StrMachine = @StrMachine 

	Open CurItens 
	Fetch Next From CurItens into @Processo 
	
	While @@Fetch_Status  = 0 
		Begin 
			Exec pTempProcNFProft_Ins @Processo, @NF, @Site, @Paridade = @Ret_Paridade OUTPUT, @Proft = @Ret_Profit OUTPUT , @ValorTotal  = @Ret_Total OUTPUT 
			If @@Error <> 0 
				Begin 
					Return -1 
					RollBack Transaction 
				End 
			Insert Into Tmp_Itens_NF Values (@StrMachine, 'XXX', 'Serviços Prestados', @Ret_Profit)
			If @@Error <> 0 
				Begin 
					Return -2
					RollBack Transaction 
				End 
			Fetch Next From CurItens into @Processo 
		End 
	Close CurItens 
	Deallocate CurItens 

	Insert Into TMP_Itens_NF 
	Select 
		@StrMachine, Cd_Tp_Tx, 'Serviços Prestados', Sum(Valor_C) - Sum(Valor_D)  as Total 
	From 
		Tmp_Pre_Itens_NF
	Where	
		Cd_Tp_Tx = 'XXX' and StrMachine = @StrMachine 
	Group by
		Cd_Tp_Tx

	If @@Error <> 0 
		Begin 
			Return -1 
			RollBack Transaction 
		End 


	Insert Into TMP_Itens_NF 
	Select 
		@StrMachine, Cd_Tp_Tx, 'Prestação de Serviços', Sum(Valor_C) - Sum(Valor_D)  as Total 
	From 
		Tmp_Pre_Itens_NF
	Where	
		Cd_Tp_Tx = '###' and StrMachine = @StrMachine 
	Group by
		Cd_Tp_Tx

	If @@Error <> 0 
		Begin 
			Return -1 
			RollBack Transaction 
		End 
	
	Insert Into TMP_Itens_NF 
	Select 
		@StrMachine, TT.Cd_Tp_Tx, TT.Nome_Tp_Tx, Sum(Valor_C) - Sum(Valor_D)  as Total 
	From 
		Tmp_Pre_Itens_NF  as Tmp Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Tmp.Cd_Tp_Tx 
	Where
		Not (TT.Cd_Tp_Tx = 'FRT'  and Left(Num_Proc, 1) = 'E') and StrMachine = @StrMachine 
	Group by 
		TT.Cd_Tp_Tx, TT.Nome_TP_Tx

	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return - 3 
		End 
	Else
		Begin 
			Commit Transaction 
			Return 1 
		End

GO
