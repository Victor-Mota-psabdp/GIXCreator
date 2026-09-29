SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pItensNFPre_Ins] 
(
@NF		VarChar(12),
@Site		Char(1), 
@Pessoa	VarChar(10), 
@StrMachine	VarChar(20) 
)
AS
	Begin Transaction 
	Delete Tmp_Pre_Itens_NF Where StrMachine = @StrMachine 
	If @@Error <> 0 
		Begin 
			Rollback Transaction 
			Return -10 
		End 
	Insert Into Tmp_Pre_Itens_NF
	Select 
		@StrMachine as 'StrMachine', Cte.Num_Proc_HIM as Num_Proc, Cd_Tp_Tx =
		Case
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx_Srv From Tipo_Taxa_Srv) Then  'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Pessoa_Tx_Exc_NF  Where Cd_Pes = @Pessoa) then 'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Taxa_Exc_NF) Then  '###'
			Else Cte.Cd_Tp_Tx
		End, 
		Vlr_C = 
		Case 
			When Cte.DC_HIM = 'C' then Cte.Vlr_Pgto_NF_HIM 
			Else 0 
		End, 
		Vlr_D = 
		Case 
			When Cte.DC_HIM = 'D' then Cte.Vlr_Pgto_NF_HIM 
			Else 0 
		End
	From 
		Cta_Cte_Hou_Imp_Mar as Cte 
	Where
		Cte.Num_NF_HIM = @NF and 
		Cte.Ref_Acesso_NF_HIM = @Site 

	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return -1 
		End 

	Insert Into Tmp_Pre_Itens_NF
	Select 
		@StrMachine as 'StrMachine', Cte.Num_Proc_HIO as Num_Proc, Cd_Tp_Tx =
		Case
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx_Srv From Tipo_Taxa_Srv) Then  'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Pessoa_Tx_Exc_NF  Where Cd_Pes = @Pessoa) then 'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Taxa_Exc_NF) Then  '###'
			Else Cte.Cd_Tp_Tx
		End, 
		Vlr_C = 
		Case 
			When Cte.DC_HIO = 'C' then Cte.Vlr_Pgto_NF_HIO 
			Else 0 
		End, 
		Vlr_D = 
		Case 
			When Cte.DC_HIO = 'D' then Cte.Vlr_Pgto_NF_HIO 
			Else 0 
		End
	From 
		Cta_Cte_Hou_Imp_Out as Cte 
	Where
		Cte.Num_NF_HIO = @NF and 
		Cte.Ref_Acesso_NF_HIO = @Site 

	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return -1 
		End 


	Insert Into Tmp_Pre_Itens_NF
	Select 
		@StrMachine as 'StrMachine', Cte.Num_Proc_HIA as Num_Proc, Cd_Tp_Tx =
		Case
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx_Srv From Tipo_Taxa_Srv) Then  'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Pessoa_Tx_Exc_NF  Where Cd_Pes = @Pessoa) then 'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Taxa_Exc_NF) Then  '###'
			Else Cte.Cd_Tp_Tx
		End, 
		Vlr_C = 
		Case 
			When Cte.DC_HIA = 'C' then Cte.Vlr_Pgto_NF_HIA
			Else 0 
		End, 
		Vlr_D = 
		Case 
			When Cte.DC_HIA = 'D' then Cte.Vlr_Pgto_NF_HIA 
			Else 0 
		End
	From 
		Cta_Cte_Hou_Imp_Aer as Cte 
	Where
		Cte.Num_NF_HIA = @NF and 
		Cte.Ref_Acesso_NF_HIA = @Site 

	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return -1 
		End 

	Insert Into Tmp_Pre_Itens_NF
	Select 
		@StrMachine as 'StrMachine', Cte.Num_Proc_HEM as Num_Proc, Cd_Tp_Tx =
		Case
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx_Srv From Tipo_Taxa_Srv) Then  'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Pessoa_Tx_Exc_NF  Where Cd_Pes = @Pessoa) then 'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Taxa_Exc_NF) Then  '###'
			Else Cte.Cd_Tp_Tx
		End, 
		Vlr_C = 
		Case 
			When Cte.DC_HEM = 'C' then Cte.Vlr_Pgto_NF_HEM 
			Else 0 
		End, 
		Vlr_D = 
		Case 
			When Cte.DC_HEM = 'D' then Cte.Vlr_Pgto_NF_HEM 
			Else 0 
		End
	From 
		Cta_Cte_Hou_Exp_Mar as Cte 
	Where
		Cte.Num_NF_HEM = @NF and 
		Cte.Ref_Acesso_NF_HEM = @Site 

	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return -1 
		End 


	Insert Into Tmp_Pre_Itens_NF
	Select 
		@StrMachine as 'StrMachine', Cte.Num_Proc_HEA as Num_Proc, Cd_Tp_Tx =
		Case
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx_Srv From Tipo_Taxa_Srv) Then  'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Pessoa_Tx_Exc_NF  Where Cd_Pes = @Pessoa) then 'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Taxa_Exc_NF) Then  '###'
			Else Cte.Cd_Tp_Tx
		End, 
		Vlr_C = 
		Case 
			When Cte.DC_HEA = 'C' then Cte.Vlr_Pgto_NF_HEA
			Else 0 
		End, 
		Vlr_D = 
		Case 
			When Cte.DC_HEA = 'D' then Cte.Vlr_Pgto_NF_HEA 
			Else 0 
		End
	From 
		Cta_Cte_Hou_Exp_Aer as Cte 
	Where
		Cte.Num_NF_HEA = @NF and 
		Cte.Ref_Acesso_NF_HEA = @Site 

	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return -1 
		End 



	Insert Into Tmp_Pre_Itens_NF
	Select 
		@StrMachine as 'StrMachine', Cte.Num_Proc_HEO as Num_Proc, Cd_Tp_Tx =
		Case
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx_Srv From Tipo_Taxa_Srv) Then  'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Pessoa_Tx_Exc_NF  Where Cd_Pes = @Pessoa) then 'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Taxa_Exc_NF) Then  '###'
			Else Cte.Cd_Tp_Tx
		End, 
		Vlr_C = 
		Case 
			When Cte.DC_HEO = 'C' then Cte.Vlr_Pgto_NF_HEO
			Else 0 
		End, 
		Vlr_D = 
		Case 
			When Cte.DC_HEO = 'D' then Cte.Vlr_Pgto_NF_HEO 
			Else 0 
		End
	From 
		Cta_Cte_Hou_Exp_Out as Cte 
	Where
		Cte.Num_NF_HEO = @NF and 
		Cte.Ref_Acesso_NF_HEO = @Site 

	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return -1 
		End 


	Insert Into Tmp_Pre_Itens_NF
	Select 
		@StrMachine as 'StrMachine', Cte.Num_Proc_MIM as Num_Proc, Cd_Tp_Tx =
		Case
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx_Srv From Tipo_Taxa_Srv) Then  'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Pessoa_Tx_Exc_NF  Where Cd_Pes = @Pessoa) then 'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Taxa_Exc_NF) Then  '###'
			Else Cte.Cd_Tp_Tx
		End, 
		Vlr_C = 
		Case 
			When Cte.DC_MIM = 'C' then Cte.Vlr_Pgto_NF_MIM 
			Else 0 
		End, 
		Vlr_D = 
		Case 
			When Cte.DC_MIM = 'D' then Cte.Vlr_Pgto_NF_MIM 
			Else 0 
		End
	From 
		Cta_Cte_Mas_Imp_Mar as Cte 
	Where
		Cte.Num_NF_MIM = @NF and 
		Cte.Ref_Acesso_NF_MIM = @Site 

	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return -1 
		End 


	Insert Into Tmp_Pre_Itens_NF
	Select 
		@StrMachine as 'StrMachine', Cte.Num_Proc_MIA as Num_Proc, Cd_Tp_Tx =
		Case
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx_Srv From Tipo_Taxa_Srv) Then  'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Pessoa_Tx_Exc_NF  Where Cd_Pes = @Pessoa) then 'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Taxa_Exc_NF) Then  '###'
			Else Cte.Cd_Tp_Tx
		End, 
		Vlr_C = 
		Case 
			When Cte.DC_MIA = 'C' then Cte.Vlr_Pgto_NF_MIA
			Else 0 
		End, 
		Vlr_D = 
		Case 
			When Cte.DC_MIA = 'D' then Cte.Vlr_Pgto_NF_MIA 
			Else 0 
		End
	From 
		Cta_Cte_Mas_Imp_Aer as Cte 
	Where
		Cte.Num_NF_MIA = @NF and 
		Cte.Ref_Acesso_NF_MIA = @Site 

	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return -1 
		End 

	Insert Into Tmp_Pre_Itens_NF
	Select 
		@StrMachine as 'StrMachine', Cte.Num_Proc_MEM as Num_Proc, Cd_Tp_Tx =
		Case
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx_Srv From Tipo_Taxa_Srv) Then  'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Pessoa_Tx_Exc_NF  Where Cd_Pes = @Pessoa) then 'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Taxa_Exc_NF) Then  '###'
			Else Cte.Cd_Tp_Tx
		End, 
		Vlr_C = 
		Case 
			When Cte.DC_MEM = 'C' then Cte.Vlr_Pgto_NF_MEM 
			Else 0 
		End, 
		Vlr_D = 
		Case 
			When Cte.DC_MEM = 'D' then Cte.Vlr_Pgto_NF_MEM 
			Else 0 
		End
	From 
		Cta_Cte_Mas_Exp_Mar as Cte 
	Where
		Cte.Num_NF_MEM = @NF and 
		Cte.Ref_Acesso_NF_MEM = @Site 

	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return -1 
		End 


	Insert Into Tmp_Pre_Itens_NF
	Select 
		@StrMachine as 'StrMachine', Cte.Num_Proc_MEA as Num_Proc, Cd_Tp_Tx =
		Case
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx_Srv From Tipo_Taxa_Srv) Then  'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Pessoa_Tx_Exc_NF  Where Cd_Pes = @Pessoa) then 'XXX'
			When Cte.Cd_Tp_Tx  in (Select Cd_Tp_Tx From Taxa_Exc_NF) Then  '###'
			Else Cte.Cd_Tp_Tx
		End, 
		Vlr_C = 
		Case 
			When Cte.DC_MEA = 'C' then Cte.Vlr_Pgto_NF_MEA
			Else 0 
		End, 
		Vlr_D = 
		Case 
			When Cte.DC_MEA = 'D' then Cte.Vlr_Pgto_NF_MEA 
			Else 0 
		End
	From 
		Cta_Cte_Mas_Exp_Aer as Cte 
	Where
		Cte.Num_NF_MEA = @NF and 
		Cte.Ref_Acesso_NF_MEA = @Site 

	If @@Error <> 0 
		Begin 
			RollBack Transaction 
			Return -1 
		End 
	Else
		Begin 
			Commit Transaction 
			Return 1 
		End


GO
