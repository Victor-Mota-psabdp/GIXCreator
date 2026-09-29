SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pResumoFatura_Rel 
AS
	Declare @QtdFatIA		Int 
	Declare @QtdFatIM		Int 
	Declare @QtdFatEA		Int 
	Declare @QtdFatEM		Int 


	Declare @VlrRSFatIA		Decimal(12,2)
	Declare @VlrRSFatIM		Decimal(12,2)
	Declare @VlrRSFatEA		Decimal(12,2)
	Declare @VlrRSFatEM		Decimal(12,2)



	Declare @VlrRSFatAVenIA	Decimal(12,2)
	Declare @VlrRSFatAVenIM	Decimal(12,2)
	Declare @VlrRSFatAVenEA	Decimal(12,2)
	Declare @VlrRSFatAVenEM	Decimal(12,2)


	Declare @VlrRSFatVenIA	Decimal(12,2)
	Declare @VlrRSFatVenIM	Decimal(12,2)
	Declare @VlrRSFatVenEA	Decimal(12,2)
	Declare @VlrRSFatVenEM	Decimal(12,2)


	
	Set @QtdFatIA = IsNull((Select count(*) From Fat_Log Where FatOper = 'I' and Left(FatCod, 2) = 'IA' and dbo.StrHoje(FatDtOper) = dbo.strhoje(getdate()) ),0)
	Set @QtdFatIM = IsNull((Select count(*) From Fat_Log Where FatOper = 'I' and Left(FatCod, 2) = 'IM' and dbo.StrHoje(FatDtOper) = dbo.strhoje(getdate()) ),0)
	Set @QtdFatEA = IsNull((Select count(*) From Fat_Log Where FatOper = 'I' and Left(FatCod, 2) = 'EA' and dbo.StrHoje(FatDtOper) = dbo.strhoje(getdate()) ),0)
	Set @QtdFatEM = IsNull((Select count(*) From Fat_Log Where FatOper = 'I' and Left(FatCod, 2) = 'EM' and dbo.StrHoje(FatDtOper) = dbo.strhoje(getdate()) ),0)

	Set @VlrRSFatIA = IsNull((Select 
						Sum(Par.Par_Moeda * Itf.Vlr_Org) 
					From 
						Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
						Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'IMA' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
					Where
						Left(Itf.FatCod, 2) = 'IA' and  Itf.Cd_Tp_Moeda <> 'REL' and 
						Fat.FatCod In 
						(Select Distinct FatCod From Fat_Log Where FatOper = 'I' and Left(FatCod, 2) = 'IA' and dbo.StrHoje(FatDtOper) = dbo.strhoje(getdate()))),0) + 

					IsNull((Select Sum(Itf.Vlr_Org) 
						From 
							Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
						Where
							Left(Itf.FatCod, 2) = 'IA' and  Itf.Cd_Tp_Moeda = 'REL' and 
							Fat.FatCod In 
							(Select Distinct FatCod From Fat_Log Where FatOper = 'I' and Left(FatCod, 2) = 'IA' and dbo.StrHoje(FatDtOper) = dbo.strhoje(getdate()))),0)



	Set @VlrRSFatIM = IsNull((Select 
					Sum(Par.Par_Moeda * Itf.Vlr_Org )
					From 
						Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
						Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'IMM' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
					Where
						Left(Itf.FatCod, 2) = 'IM' and  Itf.Cd_Tp_Moeda <> 'REL' and 
						Fat.FatCod In 
						(Select Distinct FatCod From Fat_Log Where FatOper = 'I' and Left(FatCod, 2) = 'IM' and dbo.StrHoje(FatDtOper) = dbo.strhoje(getdate()))),0) + 

					IsNull((Select Sum(Itf.Vlr_Org )
						From 
							Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
						Where
							Left(Itf.FatCod, 2) = 'IM' and  Itf.Cd_Tp_Moeda = 'REL' and 
							Fat.FatCod In 
							(Select Distinct FatCod From Fat_Log Where FatOper = 'I' and Left(FatCod, 2) = 'IM' and dbo.StrHoje(FatDtOper) = dbo.strhoje(getdate()))),0)




	Set @VlrRSFatEA = IsNull((Select 
					Sum(Par.Par_Moeda * Itf.Vlr_Org )
					From 
						Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
						Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'EXA' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
					Where
						Left(Itf.FatCod, 2) = 'EA' and  Itf.Cd_Tp_Moeda <> 'REL' and 
						Fat.FatCod In 
						(Select Distinct FatCod From Fat_Log Where FatOper = 'I' and Left(FatCod, 2) = 'EA' and dbo.StrHoje(FatDtOper) = dbo.strhoje(getdate()))),0) + 

					IsNull((Select Sum(Itf.Vlr_Org) 
						From 
							Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
						Where
							Left(Itf.FatCod, 2) = 'EA' and  Itf.Cd_Tp_Moeda = 'REL' and 
							Fat.FatCod In 
							(Select Distinct FatCod From Fat_Log Where FatOper = 'I' and Left(FatCod, 2) = 'EA' and dbo.StrHoje(FatDtOper) = dbo.strhoje(getdate()))),0)


	Set @VlrRSFatEM = IsNull((Select 
					sum(Par.Par_Moeda * Itf.Vlr_Org) 
					From 
						Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
						Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'EXM' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
					Where
						Left(Itf.FatCod, 2) = 'EM' and  Itf.Cd_Tp_Moeda <> 'REL' and 
						Fat.FatCod In 
						(Select Distinct FatCod From Fat_Log Where FatOper = 'I' and Left(FatCod, 2) = 'EM' and dbo.StrHoje(FatDtOper) = dbo.strhoje(getdate()))),0) + 

					IsNull((Select Sum(Itf.Vlr_Org )
						From 
							Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
						Where
							Left(Itf.FatCod, 2) = 'EM' and  Itf.Cd_Tp_Moeda = 'REL' and 
							Fat.FatCod In 
							(Select Distinct FatCod From Fat_Log Where FatOper = 'I' and Left(FatCod, 2) = 'EM' and dbo.StrHoje(FatDtOper) = dbo.strhoje(getdate()))),0)





			 Set @VlrRSFatVenIA = IsNull((Select 
							Sum(Par.Par_Moeda * Itf.Vlr_Org) 
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'IMA' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'IA' and  Itf.Cd_Tp_Moeda <> 'REL' and 
								FatDtVenc < GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HIA) From Caixa_Hou_Imp_Aer as Cxa Where Cxa.Num_Proc_HIA = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HIA = Itf.DC),0)) ,0) +

+ 

						 IsNull((Select 
								Sum(Vlr_Org) 
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(Dt_par) and Par.Cd_Tp_Par = 'IMA' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'IA' and  Itf.Cd_Tp_Moeda = 'REL' and 
								FatDtVenc < GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HIA) From Caixa_Hou_Imp_Aer as Cxa Where Cxa.Num_Proc_HIA = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HIA = Itf.DC),0)) ,0) 



			 Set @VlrRSFatVenIM = IsNull((Select 
						
								Sum(Par.Par_Moeda * Itf.Vlr_Org )
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'IMM' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'IM' and  Itf.Cd_Tp_Moeda <> 'REL' and 
								FatDtVenc < GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HIM) From Caixa_Hou_Imp_Mar as Cxa Where Cxa.Num_Proc_HIM = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HIM = Itf.DC),0)) ,0) +

+ 

						 IsNull((Select 
								Sum(Vlr_Org) 
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'IMM' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'IM' and  Itf.Cd_Tp_Moeda = 'REL' and 
								FatDtVenc < GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HIM) From Caixa_Hou_Imp_Mar as Cxa Where Cxa.Num_Proc_HIM = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HIM = Itf.DC),0)) ,0) 




			 Set @VlrRSFatVenEA = IsNull((Select 
							Sum(Par.Par_Moeda * Itf.Vlr_Org) 
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'EXA' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'EA' and  Itf.Cd_Tp_Moeda <> 'REL' and 
								FatDtVenc < GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HEA) From Caixa_Hou_Exp_Aer as Cxa Where Cxa.Num_Proc_HEA = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HEA = Itf.DC),0)) ,0) +

+ 

						 IsNull((Select 
								Sum(Vlr_Org)
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'EXA' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'EA' and  Itf.Cd_Tp_Moeda = 'REL' and 
								FatDtVenc < GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HEA) From Caixa_Hou_Exp_Aer as Cxa Where Cxa.Num_Proc_HEA = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HEA = Itf.DC),0)) ,0) 



			 Set @VlrRSFatVenEM = IsNull((Select 
							Sum(Par.Par_Moeda * Itf.Vlr_Org) 
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'EXM' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'EM' and  Itf.Cd_Tp_Moeda <> 'REL' and 
								FatDtVenc < GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HEM) From Caixa_Hou_Exp_Mar as Cxa Where Cxa.Num_Proc_HEM = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HEM = Itf.DC),0)) ,0) +

+ 

						 IsNull((Select 
								Sum(Vlr_Org) 
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'EXM' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'EM' and  Itf.Cd_Tp_Moeda = 'REL' and 
								FatDtVenc < GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HEM) From Caixa_Hou_Exp_Mar as Cxa Where Cxa.Num_Proc_HEM = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HEM = Itf.DC),0)) ,0) 



			 Set @VlrRSFataVenIA = IsNull((Select 
							Sum(Par.Par_Moeda * Itf.Vlr_Org) 
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'IMA' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'IA' and  Itf.Cd_Tp_Moeda <> 'REL' and 
								FatDtVenc >= GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HIA) From Caixa_Hou_Imp_Aer as Cxa Where Cxa.Num_Proc_HIA = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HIA = Itf.DC),0)) ,0) +

+ 

						 IsNull((Select 
								Sum(Vlr_Org) 
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(Dt_par) and Par.Cd_Tp_Par = 'IMA' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'IA' and  Itf.Cd_Tp_Moeda = 'REL' and 
								FatDtVenc >= GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HIA) From Caixa_Hou_Imp_Aer as Cxa Where Cxa.Num_Proc_HIA = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HIA = Itf.DC),0)) ,0) 



			 Set @VlrRSFataVenIM = IsNull((Select 
						
								Sum(Par.Par_Moeda * Itf.Vlr_Org )
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'IMM' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'IM' and  Itf.Cd_Tp_Moeda <> 'REL' and 
								FatDtVenc >= GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HIM) From Caixa_Hou_Imp_Mar as Cxa Where Cxa.Num_Proc_HIM = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HIM = Itf.DC),0)) ,0) +

+ 

						 IsNull((Select 
								Sum(Vlr_Org) 
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'IMM' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'IM' and  Itf.Cd_Tp_Moeda = 'REL' and 
								FatDtVenc >= GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HIM) From Caixa_Hou_Imp_Mar as Cxa Where Cxa.Num_Proc_HIM = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HIM = Itf.DC),0)) ,0) 




			 Set @VlrRSFataVenEA = IsNull((Select 
							Sum(Par.Par_Moeda * Itf.Vlr_Org) 
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'EXA' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'EA' and  Itf.Cd_Tp_Moeda <> 'REL' and 
								FatDtVenc >= GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HEA) From Caixa_Hou_Exp_Aer as Cxa Where Cxa.Num_Proc_HEA = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HEA = Itf.DC),0)) ,0) +

+ 

						 IsNull((Select 
								Sum(Vlr_Org)
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'EXA' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'EA' and  Itf.Cd_Tp_Moeda = 'REL' and 
								FatDtVenc >= GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HEA) From Caixa_Hou_Exp_Aer as Cxa Where Cxa.Num_Proc_HEA = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HEA = Itf.DC),0)) ,0) 



			 Set @VlrRSFataVenEM = IsNull((Select 
							Sum(Par.Par_Moeda * Itf.Vlr_Org) 
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'EXM' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'EM' and  Itf.Cd_Tp_Moeda <> 'REL' and 
								FatDtVenc >= GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HEM) From Caixa_Hou_Exp_Mar as Cxa Where Cxa.Num_Proc_HEM = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HEM = Itf.DC),0)) ,0) +

+ 

						 IsNull((Select 
								Sum(Vlr_Org) 
							From 
								Fatura as Fat join Item_Fat  as Itf on Itf.FatCod = Fat.FatCod 
								Join Paridade as Par on Par.Dt_Par = dbo.StrHoje(getdate()) and Par.Cd_Tp_Par = 'EXM' and Par.Cd_Tp_Moeda = Itf.Cd_Tp_Moeda 
							Where
								Left(Itf.FatCod, 2) = 'EM' and  Itf.Cd_Tp_Moeda = 'REL' and 
								FatDtVenc >= GetDate() and Itf.Vlr_Org <> 
								IsNull((Select Sum(Vlr_Ref_HEM) From Caixa_Hou_Exp_Mar as Cxa Where Cxa.Num_Proc_HEM = Itf.Num_Proc and Cxa.Cd_Tp_Tx = Itf.Cd_Tp_Tx and Cxa.DC_HEM = Itf.DC),0)) ,0) 





	Select 
		@QtdFatIA QtdFatIA, 
		@QtdFatIM QtdFatIM, 
		@QtdFatEA QtdFatEA,
		@QtdFatEM QtdFatEM, 
	
	
		@VlrRSFatIA VlrRSFatIA, 
		@VlrRSFatIM VlrRSFatIM, 
		@VlrRSFatEA VlrRSFatEA, 
		@VlrRSFatEM VlrRSFatEM, 
	
	
	
		@VlrRSFatAVenIA VlrRSFatAVenIA, 
		@VlrRSFatAVenIM VlrRSFatAVenIM, 
		@VlrRSFatAVenEA VlrRSFatAVenEA, 
		@VlrRSFatAVenEM VlrRSFatAVenEM, 
	
	
		@VlrRSFatVenIA VlrRSFatVenIA, 
		@VlrRSFatVenIM VlrRSFatVenIM, 
		@VlrRSFatVenEA VlrRSFatVenEA, 
		@VlrRSFatVenEM VlrRSFatVenEM

GO
