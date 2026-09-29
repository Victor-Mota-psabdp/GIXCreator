SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pTempLctoClienteNF_Ins 
(
@ID_Machine		VarChar(30),
@Cd_Pes		VarChar(10), 
@Exc			Char(1) = 'N'
)
 AS
	Begin Transaction 
	If @Exc = 'S'
		Begin 
			Exec pTempReciboNF_Del  '','', '', @Id_Machine 
			If @@Error <> 0 
				Begin 
					RollBack Transaction 
					Return -1 
				End 
			End 
	Insert Into
		Temp_Recibo_NF
		(Num_Proc, Cd_Tp_Tx, DC, ID_Machine, Cd_Tp_Moeda, Vlr_Oficial, Tx_Convers, Vlr_Pago)
	Select 
		HIM.Num_Proc_HIM as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_HIM as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HIM as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_HIM) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_HIM)
		End, 
		Sum(Vlr_Pgto_Rcto_HIM) as Vlr_Pgto  
	From 
		House_Imp_Mar as HIM  Join Cta_Cte_Hou_Imp_Mar as BaseCte on (HIM.Num_Proc_HIM = BaseCte.Num_Proc_HIM and BaseCte.Cd_Cred_Dev_HIM = @Cd_Pes )
		Join Cta_Cte_Hou_Imp_Mar as Cte on (BaseCte.Num_Proc_HIM = Cte.Num_Proc_HIM and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx)
          	 	Left Outer Join  Caixa_Hou_Imp_Mar as Cxa on (Cte.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cte.DC_HIM = Cxa.DC_HIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'IMM' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, HIM.Dt_Cheg_HIM, 105))
		Join Tipo_Taxa as TT on Cxa.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_HIM Is  Null OR
		Cte.Num_NF_HIM = '') and
		Cte.Cd_Tp_Tx Not In ('FRT') 
	Group by 
		HIM.Num_Proc_HIM, Cte.Cd_Tp_Tx, Cte.DC_HIM,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HIM 
	Union
	Select 
		HEM.Num_Proc_HEM as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_HEM as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HEM as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_HEM) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_HEM)
		End, 
		Sum(Vlr_Pgto_Rcto_HEM) as Vlr_Pgto  
	From 
		House_Exp_Mar as HEM  Join  Cta_Cte_Hou_Exp_Mar as BaseCte on (HEM.Num_Proc_HEM = BaseCte.Num_Proc_HEM and BaseCte.Cd_Cred_Dev_HEM = @Cd_Pes )
		Join Cta_Cte_Hou_Exp_Mar as Cte on (BaseCte.Num_Proc_HEM = Cte.Num_Proc_HEM and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx)
		Join Master_Exp_Mar as MEM on (HEM.Num_Proc_MEM = MEM.Num_Proc_MEM )
          	 	Left Outer Join  Caixa_Hou_Exp_Mar as Cxa on (Cte.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cte.DC_HEM = Cxa.DC_HEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXM' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MEM.Dt_Saida_MEM, 105))
		Join Tipo_Taxa as TT on Cxa.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_HEM Is  Null or  
		Cte.Num_NF_HEM = '' ) 
	Group by 
		HEM.Num_Proc_HEM, Cte.Cd_Tp_Tx, Cte.DC_HEM,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HEM
	Union
	Select 
		HIA.Num_Proc_HIA as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_HIA, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HIA as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_HIA) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_HIA)
		End, 
		Sum(Vlr_Pgto_Rcto_HIA) as Vlr_Pgto  
	From 
		House_Imp_Aer as HIA  Join Cta_Cte_Hou_Imp_Aer as BaseCte on (HIA.Num_Proc_HIA = BaseCte.Num_Proc_HIA and  BaseCte.Cd_Cred_Dev_HIA = @Cd_Pes )
		Join Cta_Cte_Hou_Imp_Aer as Cte on (BaseCte.Num_Proc_HIA = Cte.Num_Proc_HIA and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx)
		Join Master_Imp_Aer as MIA on (HIA.Num_Proc_HIA = MIA.Num_Proc_MIA)
          	 	Left Outer Join  Caixa_Hou_Imp_Aer as Cxa on (Cte.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cte.DC_HIA = Cxa.DC_HIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'IMA' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MIA.Dt_Cheg_MIA, 105))
		Join Tipo_Taxa as TT on Cxa.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_HIA Is Null or 
		Cte.Num_NF_HIA = '') and
		Cte.Cd_Tp_Tx Not In ('FRT') and 
		Convert(DateTime, Dt_Pgto_Rcto_HIA, 105) >= '2002-01-01'  
	Group by 
		HIA.Num_Proc_HIA, Cte.Cd_Tp_Tx, Cte.DC_HIA,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HIA
	Union
	Select 
		HEA.Num_Proc_HEA as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_HEA as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HEA as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_HEA) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_HEA)
		End, 		
		Sum(Vlr_Pgto_Rcto_HEA) as Vlr_Pgto  
	From 
		House_Exp_Aer as HEA  Join  Cta_Cte_Hou_Exp_Aer as BaseCte on (HEA.Num_Proc_HEA = BaseCte.Num_Proc_HEA and BaseCte.Cd_Cred_Dev_HEA = @Cd_Pes )
		Join Cta_Cte_Hou_Exp_Aer as Cte on (BaseCte.Num_Proc_HEA = Cte.Num_Proc_HEA and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx)
		Join Master_Exp_Aer as MEA on (HEA.Num_Proc_MEA = MEA.Num_Proc_MEA )
          	 	Left Outer Join  Caixa_Hou_Exp_Aer as Cxa on (Cte.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cte.DC_HEA = Cxa.DC_HEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'EXA' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MEA.Dt_Saida_MEA, 105))
		Join Tipo_Taxa as TT on Cxa.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_HEA Is Null or 
		Cte.Num_NF_HEA = '') and
		Convert(DateTime, Dt_Pgto_Rcto_HEA, 105) >= '2002-01-01'  
	Group by 
		HEA.Num_Proc_HEA, Cte.Cd_Tp_Tx, Cte.DC_HEA,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HEA
	Exec pTempLctoReciboNFMaster_Ins  @ID_Machine, @Cd_Pes
	Commit Transaction
	Return 1



GO
