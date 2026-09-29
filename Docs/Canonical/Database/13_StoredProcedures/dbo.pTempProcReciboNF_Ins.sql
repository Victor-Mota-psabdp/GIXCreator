SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[pTempProcReciboNF_Ins] 
(
@Num_Proc		Varchar(16), 
@Cd_Tp_Tx 		VarChar(3), 
@DC			Char(1), 
@Cd_Cliente		VarChar(10), 
@ID_Machine 		VarChar(50) 
)
 AS
	Declare @Proc 	VarChar(16) 
	Begin Transaction 
	Set @Cd_Tp_Tx = Rtrim(@Cd_Tp_Tx)
	Insert Into
		Temp_Recibo_NF
		(Num_Proc, Cd_Tp_Tx, DC, ID_Machine, Cd_Tp_Moeda, Vlr_Oficial, Tx_Convers, Vlr_Pago, Cd_Pes)
	Select 
		HIM.Num_Proc_HIM as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_HIM as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HIM as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_HIM) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_HIM)
		End, 
		Sum(Vlr_Pgto_Rcto_HIM) as Vlr_Pgto, @Cd_Cliente
	From 
		House_Imp_Mar as HIM  Join Cta_Cte_Hou_Imp_Mar as BaseCte on (HIM.Num_Proc_HIM = BaseCte.Num_Proc_HIM and BaseCte.Cd_Cred_Dev_HIM = @Cd_Cliente)
		Join Cta_Cte_Hou_Imp_Mar as Cte on (BaseCte.Num_Proc_HIM = Cte.Num_Proc_HIM and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx)
          	 	Left Outer Join  Caixa_Hou_Imp_Mar as Cxa on (Cte.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cte.DC_HIM = Cxa.DC_HIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, HIM.Dt_Cheg_HIM, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_HIM Is  Null OR
		Cte.Num_NF_HIM = '') and
		Cte.Cd_Tp_Tx Not In ('FRT')  and 
		Cte.Num_Proc_HIM like  @Num_Proc and 
		Cte.Cd_Tp_Tx Like @Cd_Tp_Tx  and 
		Cte.DC_HIM Like @DC and 
		Cte.Cd_Tp_Tx Not In 
		(Select Cd_Tp_Tx From Temp_Recibo_NF as TR Where TR.Num_Proc = HIM.Num_Proc_HIM and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_HIM)
	Group by 
		HIM.Num_Proc_HIM, Cte.Cd_Tp_Tx, Cte.DC_HIM, Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HIM
	Union

	Select 
		HIO.Num_Proc_HIO as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_HIO as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HIO as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_HIO) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_HIO)
		End, 
		Sum(Vlr_Pgto_Rcto_HIO) as Vlr_Pgto, @Cd_Cliente
	From 
		House_Imp_Out as HIO  Join Cta_Cte_Hou_Imp_Out as BaseCte on (HIO.Num_Proc_HIO = BaseCte.Num_Proc_HIO and BaseCte.Cd_Cred_Dev_HIO = @Cd_Cliente)
		Join Cta_Cte_Hou_Imp_Out as Cte on (BaseCte.Num_Proc_HIO = Cte.Num_Proc_HIO and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx)
          	 	Left Outer Join  Caixa_Hou_Imp_Out as Cxa on (Cte.Num_Proc_HIO = Cxa.Num_Proc_HIO and Cte.DC_HIO = Cxa.DC_HIO and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, HIO.Dt_Emis_HIO, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_HIO Is  Null OR
		Cte.Num_NF_HIO = '') and
		Cte.Cd_Tp_Tx Not In ('FRT')  and 
		Cte.Num_Proc_HIO like  @Num_Proc and 
		Cte.Cd_Tp_Tx Like @Cd_Tp_Tx  and 
		Cte.DC_HIO Like @DC and 
		Cte.Cd_Tp_Tx Not In 
		(Select Cd_Tp_Tx From Temp_Recibo_NF as TR Where TR.Num_Proc = HIO.Num_Proc_HIO and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_HIO)
	Group by 
		HIO.Num_Proc_HIO, Cte.Cd_Tp_Tx, Cte.DC_HIO, Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HIO 


	Union
	Select 
		HEM.Num_Proc_HEM as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx,Cte.DC_HEM as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HEM as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_HEM) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_HEM)
		End, 
		Sum(Vlr_Pgto_Rcto_HEM) as Vlr_Pgto, @Cd_Cliente
	From  
		House_Exp_Mar as HEM  Join  Cta_Cte_Hou_Exp_Mar as BaseCte on (HEM.Num_Proc_HEM = BaseCte.Num_Proc_HEM and BaseCte.Cd_Cred_Dev_HEM = @Cd_Cliente)
		Join Cta_Cte_Hou_Exp_Mar as Cte on (BaseCte.Num_Proc_HEM = Cte.Num_Proc_HEM and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx  )
		Join Master_Exp_Mar as MEM on (HEM.Num_Proc_MEM = MEM.Num_Proc_MEM )
          	 	Left Outer Join  Caixa_Hou_Exp_Mar as Cxa on (Cte.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cte.DC_HEM = Cxa.DC_HEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MEM.Dt_Saida_MEM, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_HEM Is  Null OR
		Cte.Num_NF_HEM = '') and
		Cte.Num_Proc_HEM like  @Num_Proc and 
		Cte.Cd_Tp_Tx Like @Cd_Tp_Tx  and 
		Cte.DC_HEM Like @DC and 
		Cte.Cd_Tp_Tx Not In 
		(Select Cd_Tp_Tx From Temp_Recibo_NF as TR Where TR.Num_Proc = HEM.Num_Proc_HEM and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_HEM)
	Group by 
		HEM.Num_Proc_HEM, Cte.Cd_Tp_Tx, Cte.DC_HEM, Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HEM
	Union

	Select 
		HEO.Num_Proc_HEO as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx,Cte.DC_HEO as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HEO as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_HEO) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_HEO)
		End, 
		Sum(Vlr_Pgto_Rcto_HEO) as Vlr_Pgto, @Cd_Cliente
	From  
		House_Exp_Out as HEO  Join  Cta_Cte_Hou_Exp_Out as BaseCte on (HEO.Num_Proc_HEO = BaseCte.Num_Proc_HEO and BaseCte.Cd_Cred_Dev_HEO = @Cd_Cliente)
		Join Cta_Cte_Hou_Exp_Out as Cte on (BaseCte.Num_Proc_HEO = Cte.Num_Proc_HEO and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx  )
          	Left Outer Join  Caixa_Hou_Exp_Out as Cxa on (Cte.Num_Proc_HEO = Cxa.Num_Proc_HEO and Cte.DC_HEO = Cxa.DC_HEO and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, Dt_Emis_HEO, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_HEO Is  Null OR
		Cte.Num_NF_HEO = '') and
		Cte.Num_Proc_HEO like  @Num_Proc and 
		Cte.Cd_Tp_Tx Like @Cd_Tp_Tx  and 
		Cte.DC_HEO Like @DC and 
		Cte.Cd_Tp_Tx Not In 
		(Select Cd_Tp_Tx From Temp_Recibo_NF as TR Where TR.Num_Proc = HEO.Num_Proc_HEO and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_HEO)
	Group by 
		HEO.Num_Proc_HEO, Cte.Cd_Tp_Tx, Cte.DC_HEO, Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HEO

	Union
	Select 
		HIA.Num_Proc_HIA as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_HIA as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HIA as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_HIA) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_HIA )
		End, 
		Sum(Vlr_Pgto_Rcto_HIA) as Vlr_Pgto, @Cd_Cliente
	From 
		House_Imp_Aer as HIA  Join Cta_Cte_Hou_Imp_Aer as BaseCte on (HIA.Num_Proc_HIA = BaseCte.Num_Proc_HIA and BaseCte.Cd_Cred_Dev_HIA = @Cd_Cliente )
		Join Cta_Cte_Hou_Imp_Aer as Cte on (BaseCte.Num_Proc_HIA = Cte.Num_Proc_HIA and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx  )
		Join Master_Imp_Aer as MIA on (HIA.Num_Proc_MIA = MIA.Num_Proc_MIA)
          	 	Left Outer Join  Caixa_Hou_Imp_Aer as Cxa on (Cte.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cte.DC_HIA = Cxa.DC_HIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MIA.Dt_Cheg_MIA, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_HIA Is  Null OR
		Cte.Num_NF_HIA= '') and
		Cte.Cd_Tp_Tx Not In ('FRT')  and 
		Cte.Num_Proc_HIA like  @Num_Proc and 
		Cte.Cd_Tp_Tx Like @Cd_Tp_Tx  and 
		Cte.DC_HIA Like @DC and 
		Cte.Cd_Tp_Tx Not In 
		(Select Cd_Tp_Tx From Temp_Recibo_NF as TR Where TR.Num_Proc = HIA.Num_Proc_HIA and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_HIA)
	Group by 
		HIA.Num_Proc_HIA, Cte.Cd_Tp_Tx, Cte.DC_HIA, Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HIA
	Union
	Select 
		HEA.Num_Proc_HEA as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx,Cte.DC_HEA as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HEA as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_HEA) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_HEA )
		End, 		
		Sum(Vlr_Pgto_Rcto_HEA) as Vlr_Pgto, @Cd_Cliente
	From 
		House_Exp_Aer as HEA  Join  Cta_Cte_Hou_Exp_Aer as BaseCte on (HEA.Num_Proc_HEA = BaseCte.Num_Proc_HEA and BaseCte.Cd_Cred_Dev_HEA = @Cd_Cliente)
		Join Cta_Cte_Hou_Exp_Aer as Cte on (BaseCte.Num_Proc_HEA = Cte.Num_Proc_HEA and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx  )
		Join Master_Exp_Aer as MEA on (HEA.Num_Proc_MEA = MEA.Num_Proc_MEA )
          	 	Left Outer Join  Caixa_Hou_Exp_Aer as Cxa on (Cte.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cte.DC_HEA = Cxa.DC_HEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MEA.Dt_Saida_MEA, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_HEA Is  Null OR
		Cte.Num_NF_HEA = '') and
		Cte.Num_Proc_HEA like  @Num_Proc and 
		Cte.Cd_Tp_Tx Like @Cd_Tp_Tx  and 
		Cte.DC_HEA Like @DC and 
		Cte.Cd_Tp_Tx Not In 
		(Select Cd_Tp_Tx From Temp_Recibo_NF as TR Where TR.Num_Proc = HEA.Num_Proc_HEA and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_HEA)
	Group by 
		HEA.Num_Proc_HEA, Cte.Cd_Tp_Tx, Cte.DC_HEA, Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_HEA
	Union 
	Select 
		MIM.Num_Proc_MIM as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_MIM as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MIM as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_MIM) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_MIM)
		End, 
		Sum(Vlr_Pgto_Rcto_MIM) as Vlr_Pgto, @Cd_Cliente 
	From 
		Master_Imp_Mar as MIM  Join Cta_Cte_Mas_Imp_Mar as BaseCte on (MIM.Num_Proc_MIM = BaseCte.Num_Proc_MIM and BaseCte.Cd_Cred_Dev_MIM = @Cd_Cliente)
		Join Cta_Cte_Mas_Imp_Mar as Cte on (BaseCte.Num_Proc_MIM = Cte.Num_Proc_MIM and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx)
          	 	Left Outer Join  Caixa_Mas_Imp_Mar as Cxa on (Cte.Num_Proc_MIM = Cxa.Num_Proc_MIM and Cte.DC_MIM = Cxa.DC_MIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MIM.Dt_Atrac_MIM, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_MIM Is  Null OR
		Cte.Num_NF_MIM = '') and
		Cte.Cd_Tp_Tx Not In ('FRT')  and 
		Cte.Num_Proc_MIM like  @Num_Proc and 
		Cte.Cd_Tp_Tx Like @Cd_Tp_Tx  and 
		Cte.DC_MIM Like @DC and 
		Cte.Cd_Tp_Tx Not In 
		(Select Cd_Tp_Tx From Temp_Recibo_NF as TR Where TR.Num_Proc = MIM.Num_Proc_MIM and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_MIM)
	Group by 
		MIM.Num_Proc_MIM, Cte.Cd_Tp_Tx, Cte.DC_MIM, Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MIM
	Union
	Select 
		MEM.Num_Proc_MEM as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx,Cte.DC_MEM as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MEM as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_MEM) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_MEM)
		End, 
		Sum(Vlr_Pgto_Rcto_MEM) as Vlr_Pgto, @Cd_Cliente 
	From 
		Master_Exp_Mar as MEM  Join  Cta_Cte_Mas_Exp_Mar as BaseCte on (MEM.Num_Proc_MEM = BaseCte.Num_Proc_MEM and BaseCte.Cd_Cred_Dev_MEM = @Cd_Cliente)
		Join Cta_Cte_Mas_Exp_Mar as Cte on (BaseCte.Num_Proc_MEM = Cte.Num_Proc_MEM and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx  )
		Left Outer Join  Caixa_Mas_Exp_Mar as Cxa on (Cte.Num_Proc_MEM = Cxa.Num_Proc_MEM and Cte.DC_MEM = Cxa.DC_MEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MEM.Dt_Saida_MEM, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_MEM Is  Null OR
		Cte.Num_NF_MEM = '') and
		Cte.Num_Proc_MEM like  @Num_Proc and 
		Cte.Cd_Tp_Tx Like @Cd_Tp_Tx  and 
		Cte.DC_MEM Like @DC and 
		Cte.Cd_Tp_Tx Not In 
		(Select Cd_Tp_Tx From Temp_Recibo_NF as TR Where TR.Num_Proc = MEM.Num_Proc_MEM and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_MEM)
	Group by 
		MEM.Num_Proc_MEM, Cte.Cd_Tp_Tx, Cte.DC_MEM, Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MEM
	Union
	Select 
		MIA.Num_Proc_MIA as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx, Cte.DC_MIA as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MIA as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_MIA) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_MIA )
		End, 
		Sum(Vlr_Pgto_Rcto_MIA) as Vlr_Pgto, @Cd_Cliente 
	From 
		Master_Imp_Aer as MIA  Join Cta_Cte_Mas_Imp_Aer as BaseCte on (MIA.Num_Proc_MIA = BaseCte.Num_Proc_MIA and BaseCte.Cd_Cred_Dev_MIA = @Cd_Cliente )
		Join Cta_Cte_Mas_Imp_Aer as Cte on (BaseCte.Num_Proc_MIA = Cte.Num_Proc_MIA and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx  )
		Left Outer Join  Caixa_Mas_Imp_Aer as Cxa on (Cte.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cte.DC_MIA = Cxa.DC_MIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MIA.Dt_Cheg_MIA, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_MIA Is  Null OR
		Cte.Num_NF_MIA= '') and
		Cte.Num_Proc_MIA like  @Num_Proc and 
		Cte.Cd_Tp_Tx Like @Cd_Tp_Tx  and 
		Cte.DC_MIA Like @DC and 
		Cte.Cd_Tp_Tx Not In ('FRT')  and 
		Cte.Cd_Tp_Tx Not In 
		(Select Cd_Tp_Tx From Temp_Recibo_NF as TR Where TR.Num_Proc = MIA.Num_Proc_MIA and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_MIA)
	Group by 
		MIA.Num_Proc_MIA, Cte.Cd_Tp_Tx, Cte.DC_MIA, Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MIA
	Union
	Select 
		MEA.Num_Proc_MEA as Processo, Cte.Cd_Tp_Tx as Cd_Tp_Tx,Cte.DC_MEA as DC, @ID_Machine,  Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MEA as Vlr_Org,  
		Paridade = 
		Case  
			When Avg(Cxa.Par_Moeda_MEA) Is Null Then Avg(Par.Par_Moeda)
			Else Avg(Cxa.Par_Moeda_MEA )
		End, 		
		Sum(Vlr_Pgto_Rcto_MEA) as Vlr_Pgto, @Cd_Cliente 
	From 
		Master_Exp_Aer as MEA  Join  Cta_Cte_Mas_Exp_Aer as BaseCte on (MEA.Num_Proc_MEA = BaseCte.Num_Proc_MEA and BaseCte.Cd_Cred_Dev_MEA = @Cd_Cliente)
		Join Cta_Cte_Mas_Exp_Aer as Cte on (BaseCte.Num_Proc_MEA = Cte.Num_Proc_MEA and BaseCte.Cd_Tp_Tx = Cte.Cd_Tp_Tx  )
		Left Outer Join  Caixa_Mas_Exp_Aer as Cxa on (Cte.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cte.DC_MEA = Cxa.DC_MEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx )
		Left Outer Join Paridade as Par on (Cte.Cd_Tp_Moeda = Par.Cd_Tp_Moeda and Par.Cd_Tp_Par = 'OFC' and Convert(DateTime, Dt_Par, 105) = Convert(DateTime, MEA.Dt_Saida_MEA, 105))
		Join Tipo_Taxa as TT on Cte.Cd_Tp_Tx = TT.Cd_Tp_Tx
	Where
		(Cte.Num_NF_MEA Is  Null OR
		Cte.Num_NF_MEA = '') and
		Cte.Num_Proc_MEA like  @Num_Proc and 
		Cte.Cd_Tp_Tx Like @Cd_Tp_Tx  and 
		Cte.DC_MEA Like @DC and 
		Cte.Cd_Tp_Tx Not In 
		(Select Cd_Tp_Tx From Temp_Recibo_NF as TR Where TR.Num_Proc = MEA.Num_Proc_MEA and TR.Cd_Tp_Tx = Cte.Cd_Tp_Tx and TR.DC = Cte.DC_MEA)
	Group by 
		MEA.Num_Proc_MEA, Cte.Cd_Tp_Tx, Cte.DC_MEA, Cte.Cd_Tp_Moeda,  Cte.Vlr_Org_MEA
	Order by 
		Processo, Cd_Tp_Tx
--	Declare Cur_Processos Cursor For 
--	Select 
--		Distinct Num_Proc 
--	From 
--		Temp_Recibo_NF
--	Where
--		ID_Machine = @ID_Machine 
	
--	Open Cur_Processos 
--	Fetch Next From Cur_Processos  Into @Proc 
--	While @@Fetch_Status = 0 
--		Begin 
--			If Len(@Proc) = 16 
--				Begin 
--					Exec pTempProcNFProft_Upd @Proc, @Id_Machine 
--				End 	
--			Fetch Next From Cur_Processos  Into @Proc 
--		End 
--	Close Cur_Processos 
--	Deallocate Cur_Processos 
	Commit Transaction
	Return 1
GO
