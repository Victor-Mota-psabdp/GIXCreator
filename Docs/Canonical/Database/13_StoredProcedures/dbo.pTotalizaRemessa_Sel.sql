SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTotalizaRemessa_Sel 
(
@Tipo			Char(1),
@Num_Ref		VarChar(12), 
@QtdHouse		Int=Null OUTPUT, 
@VlrDol			Decimal(10,2)=Null OUTPUT,
@VlrOut		Decimal(10,2)=Null OUTPUT,
@VlrFech		Decimal(10,2)=Null OUTPUT,
@VlrRem		Decimal(10,2)=Null OUTPUT
)
AS
	Declare @TxUSS	Float
	Declare @TxOut	Float 
	Declare @TxFech	Float 
	If @Tipo = 'A'
		Begin 
			Begin Transaction 
			Set @VlrDol  = IsNull((Select Sum(Vlr_Org_HEA) From Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cta on (Cxa.Num_Proc_HEA = Cta.Num_Proc_HEA and Cxa.DC_HEA = Cta.DC_HEA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEA = @Num_Ref and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HEA = 'D'),0) -  IsNull((Select Sum(Vlr_Org_HEA) From Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cta on (Cxa.Num_Proc_HEA = Cta.Num_Proc_HEA and Cxa.DC_HEA = Cta.DC_HEA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEA = @Num_Ref and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HEA = 'C'),0)
			Set @VlrOut = IsNull((Select Sum(Vlr_Org_HEA) From 	Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cta on (Cxa.Num_Proc_HEA = Cta.Num_Proc_HEA and Cxa.DC_HEA = Cta.DC_HEA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEA = @Num_Ref and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HEA = 'D'),0) -  IsNull((Select Sum(Vlr_Org_HEA) From Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cta on (Cxa.Num_Proc_HEA = Cta.Num_Proc_HEA and Cxa.DC_HEA = Cta.DC_HEA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEA = @Num_Ref and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HEA = 'C'),0)
			Set @QtdHouse = IsNull((Select Count(Num_Proc_HEA) From Caixa_Hou_Exp_Aer Where Num_Rcb_HEA = @Num_Ref),0) 
		
			Set @VlrDol  = @VlrDol + (IsNull((Select Sum(Vlr_Org_HIA) From Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cta on (Cxa.Num_Proc_HIA = Cta.Num_Proc_HIA and Cxa.DC_HIA = Cta.DC_HIA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIA = @Num_Ref and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HIA = 'D'),0) -  IsNull((Select Sum(Vlr_Org_HIA) From Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cta on (Cxa.Num_Proc_HIA = Cta.Num_Proc_HIA and Cxa.DC_HIA = Cta.DC_HIA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIA = @Num_Ref and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HIA = 'C'),0))
			Set @VlrOut = @VlrOut + (IsNull((Select Sum(Vlr_Org_HIA) From Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cta on (Cxa.Num_Proc_HIA = Cta.Num_Proc_HIA and Cxa.DC_HIA = Cta.DC_HIA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIA = @Num_Ref and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HIA = 'D'),0) -  IsNull((Select Sum(Vlr_Org_HIA) From Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cta on (Cxa.Num_Proc_HIA = Cta.Num_Proc_HIA and Cxa.DC_HIA = Cta.DC_HIA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIA = @Num_Ref and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HIA = 'C'),0))
			Set @QtdHouse = @QtdHouse + IsNull((Select Count(Num_Proc_HIA) From Caixa_Hou_Imp_Aer Where Num_Rcb_HIA = @Num_Ref),0) 

			Set @TxUSS = IsNull((Select Tx_Dol_RA From Remessa_Aer Where Num_Ref_RA = @Num_Ref),0)
			Set @TxOut = IsNull((Select Tx_Conv_RA From Remessa_Aer Where Num_Ref_RA = @Num_Ref),0)
			Set @TxFech = IsNull((Select Tx_Fchto_RA From Remessa_Aer Where Num_Ref_RA = @Num_Ref),0)

			Set @VlrFech = (@VlrDol * @TxUSS) + (@VlrOut * @TxOut)  
			Set @VlrRem =  @VlrFech * @TxFech

			Update 
				Remessa_Aer 
			Set 
				Vlr_Tot_Dol_RA = @VlrDol, 
				Vlr_Tot_Conv_RA = @VlrOut, 
				Vlr_Tot_Fchto_RA = @VlrFech, 
				Vlr_Tot_RA = @VlrRem
			Where 
				Num_Ref_RA = @Num_Ref

			Commit Transaction 
		End
	Else
		Begin 
			Begin Transaction 
			Set @VlrDol  = IsNull((Select Sum(Vlr_Org_HEM) From Caixa_Hou_Exp_Mar as Cxa Join Cta_Cte_Hou_Exp_Mar as Cta on (Cxa.Num_Proc_HEM = Cta.Num_Proc_HEM and Cxa.DC_HEM = Cta.DC_HEM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEM = @Num_Ref and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HEM = 'D'),0) -  IsNull((Select Sum(Vlr_Org_HEM) From Caixa_Hou_Exp_Mar as Cxa Join Cta_Cte_Hou_Exp_Mar as Cta on (Cxa.Num_Proc_HEM = Cta.Num_Proc_HEM and Cxa.DC_HEM = Cta.DC_HEM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEM = @Num_Ref and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HEM = 'C'),0)
			Set @VlrOut = IsNull((Select Sum(Vlr_Org_HEM) From Caixa_Hou_Exp_Mar as Cxa Join Cta_Cte_Hou_Exp_Mar as Cta on (Cxa.Num_Proc_HEM = Cta.Num_Proc_HEM and Cxa.DC_HEM = Cta.DC_HEM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEM = @Num_Ref and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HEM = 'D'),0) -  IsNull((Select Sum(Vlr_Org_HEM) From Caixa_Hou_Exp_Mar as Cxa Join Cta_Cte_Hou_Exp_Mar as Cta on (Cxa.Num_Proc_HEM = Cta.Num_Proc_HEM and Cxa.DC_HEM = Cta.DC_HEM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEM = @Num_Ref and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HEM = 'C'),0)
			Set @QtdHouse = IsNull((Select Count(Num_Proc_HEM) From Caixa_Hou_Exp_Mar Where Num_Rcb_HEM = @Num_Ref),0) 
		
			Set @VlrDol  = @VlrDol + (IsNull((Select Sum(Vlr_Org_HIM) From Caixa_Hou_Imp_Mar as Cxa Join Cta_Cte_Hou_Imp_Mar as Cta on (Cxa.Num_Proc_HIM = Cta.Num_Proc_HIM and Cxa.DC_HIM = Cta.DC_HIM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIM = @Num_Ref and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HIM = 'D'),0) -  IsNull((Select Sum(Vlr_Org_HIM) From Caixa_Hou_Imp_Mar as Cxa Join Cta_Cte_Hou_Imp_Mar as Cta on (Cxa.Num_Proc_HIM = Cta.Num_Proc_HIM and Cxa.DC_HIM = Cta.DC_HIM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIM = @Num_Ref and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HIM = 'C'),0))
			Set @VlrOut = @VlrOut + (IsNull((Select Sum(Vlr_Org_HIM) From Caixa_Hou_Imp_Mar as Cxa Join Cta_Cte_Hou_Imp_Mar as Cta on (Cxa.Num_Proc_HIM = Cta.Num_Proc_HIM and Cxa.DC_HIM = Cta.DC_HIM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIM = @Num_Ref and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HIM = 'D'),0) -  IsNull((Select Sum(Vlr_Org_HIM) From Caixa_Hou_Imp_Mar as Cxa Join Cta_Cte_Hou_Imp_Mar as Cta on (Cxa.Num_Proc_HIM = Cta.Num_Proc_HIM and Cxa.DC_HIM = Cta.DC_HIM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIM = @Num_Ref and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HIM = 'C'),0))
			Set @QtdHouse = @QtdHouse + IsNull((Select Count(Num_Proc_HIM) From Caixa_Hou_Imp_Mar Where Num_Rcb_HIM = @Num_Ref),0) 


			Set @TxUSS = IsNull((Select Tx_Dol_RM From Remessa_Mar Where Num_Ref_RM = @Num_Ref),0)
			Set @TxOut = IsNull((Select Tx_Conv_RM From Remessa_Mar Where Num_Ref_RM = @Num_Ref),0)
			Set @TxFech = IsNull((Select Tx_Fchto_RM From Remessa_Mar Where Num_Ref_RM = @Num_Ref),0)

			Set @VlrFech = (@VlrDol * @TxUSS) + (@VlrOut * @TxOut)  
			Set @VlrRem =  @VlrFech * @TxFech

			Update 
				Remessa_Mar
			Set 
				Vlr_Tot_Dol_RM = @VlrDol, 
				Vlr_Tot_Conv_RM = @VlrOut, 
				Vlr_Tot_Fchto_RM = @VlrFech, 
				Vlr_Tot_RM = @VlrRem
			Where 
				Num_Ref_RM = @Num_Ref

			Commit Transaction 

		End

GO
