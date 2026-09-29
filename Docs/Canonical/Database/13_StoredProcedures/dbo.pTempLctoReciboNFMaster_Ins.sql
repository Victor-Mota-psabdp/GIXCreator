SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pTempLctoReciboNFMaster_Ins 
(
@Num_Lcto		VarChar(12),
@ID_Machine		VarChar(30),
@Cd_Pes		VarChar(10), 
@Exc			Char(1) = 'N'
)
 AS
	Insert Into
		Temp_Recibo_NF
		(Num_Proc, Cd_Tp_Tx, DC, ID_Machine, Cd_Tp_Moeda, Vlr_Oficial, Tx_Convers, Vlr_Pago)
	Select 
		MIM.Num_Proc_MIM as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_MIM as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MIM as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_MIM) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_MIM)
		End, 
		Sum(Vlr_Pgto_Rcto_MIM) as Vlr_Pgto  
	From 
		Master_Imp_Mar as MIM Join Cta_Cte_Mas_Imp_Mar as BaseCte on (MIM.Num_Proc_MIM = BaseCte.Num_Proc_MIM)
		Join Cta_Cte_Mas_Imp_Mar as Cte on (BaseCte.Num_Proc_MIM = Cte.Num_Proc_MIM and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx)
          	 	Left Outer Join  Caixa_Mas_Imp_Mar as Cxa on (Cte.Num_Proc_MIM = Cxa.Num_Proc_MIM and Cte.DC_MIM = Cxa.DC_MIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MIM.Dt_Atrac_MIM, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_MIM Is  Null OR
		Cte.Num_NF_MIM = '') and
		Cte.Cd_Tp_Tx Not In ('FRT') and 
		Cxa.Num_Lcto = @Num_Lcto 
	Group by 
		MIM.Num_Proc_MIM, Cte.Cd_Tp_Tx, Cte.DC_MIM,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MIM
	Union 
	Select 
		MEM.Num_Proc_MEM as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_MEM as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MEM as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_MEM) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_MEM)
		End, 
		Sum(Vlr_Pgto_Rcto_MEM) as Vlr_Pgto  
	From 
		Master_Exp_Mar as MEM Join Cta_Cte_Mas_Exp_Mar as BaseCte on (MEM.Num_Proc_MEM = BaseCte.Num_Proc_MEM)
		Join Cta_Cte_Mas_Exp_Mar as Cte on (BaseCte.Num_Proc_MEM = Cte.Num_Proc_MEM and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx)
          	 	Left Outer Join  Caixa_Mas_Exp_Mar as Cxa on (Cte.Num_Proc_MEM = Cxa.Num_Proc_MEM and Cte.DC_MEM = Cxa.DC_MEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MEM.Dt_Saida_MEM, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_MEM Is  Null OR
		Cte.Num_NF_MEM = '') and
		Cxa.Num_Lcto = @Num_Lcto 
	Group by 
		MEM.Num_Proc_MEM, Cte.Cd_Tp_Tx, Cte.DC_MEM,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MEM
	Union 
	Select 
		MIA.Num_Proc_MIA as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_MIA as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MIA as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_MIA) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_MIA)
		End, 
		Sum(Vlr_Pgto_Rcto_MIA) as Vlr_Pgto  
	From 
		Master_Imp_Aer as MIA Join Cta_Cte_Mas_Imp_Aer as BaseCte on (MIA.Num_Proc_MIA = BaseCte.Num_Proc_MIA)
		Join Cta_Cte_Mas_Imp_Aer as Cte on (BaseCte.Num_Proc_MIA = Cte.Num_Proc_MIA and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx)
          	 	Left Outer Join  Caixa_Mas_Imp_Aer as Cxa on (Cte.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cte.DC_MIA = Cxa.DC_MIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MIA.Dt_Cheg_MIA, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_MIA Is  Null OR
		Cte.Num_NF_MIA = '') and
		Cte.Cd_Tp_Tx Not In ('FRT') and 
		Cxa.Num_Lcto = @Num_Lcto 
	Group by 
		MIA.Num_Proc_MIA, Cte.Cd_Tp_Tx, Cte.DC_MIA,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MIA
	Union 
	Select 
		MEA.Num_Proc_MEA as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_MEA as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MEA as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_MEA) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_MEA)
		End, 
		Sum(Vlr_Pgto_Rcto_MEA) as Vlr_Pgto  
	From 
		Master_Exp_Aer as MEA Join Cta_Cte_Mas_Exp_Aer as BaseCte on (MEA.Num_Proc_MEA = BaseCte.Num_Proc_MEA)
		Join Cta_Cte_Mas_Exp_Aer as Cte on (BaseCte.Num_Proc_MEA = Cte.Num_Proc_MEA and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx)
          	 	Left Outer Join  Caixa_Mas_Exp_Aer as Cxa on (Cte.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cte.DC_MEA = Cxa.DC_MEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MEA.Dt_Saida_MEA, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_MEA Is  Null OR
		Cte.Num_NF_MEA = '') and
		Cxa.Num_Lcto = @Num_Lcto 
	Group by 
		MEA.Num_Proc_MEA, Cte.Cd_Tp_Tx, Cte.DC_MEA,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MEA
	Commit Transaction
	Return 1



GO
