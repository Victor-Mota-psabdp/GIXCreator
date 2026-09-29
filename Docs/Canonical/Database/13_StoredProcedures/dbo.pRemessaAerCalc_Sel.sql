SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessaAerCalc_Sel 
(
@Num_Ref_RA		VarChar(12), 
@Dt_Oper_RA		VarChar(10), 
@Dt_RA 		VarChar(10),
@Tx_Dol_RA 		Float, 
@Tx_Conv_RA 		Float, 
@Tx_Fchto_RA		Float,
@Usuario		VarChar(10), 
@QtdHouse		Int=Null OUTPUT, 
@VlrDol			Float=Null OUTPUT,
@VlrOut		Float=Null OUTPUT
)
AS
	Begin Transaction 
	If @Dt_RA = Null or @Dt_RA =''
		Update 
			Caixa_Hou_Exp_Aer 
		Set 
         			Num_Lcto = 'PROVISÓRIO',
		         	Dt_Conv_HEA = @Dt_Oper_RA, 
         			Dt_Pgto_Rcto_HEA = @Dt_Oper_RA
		Where 
			Num_Rcb_HEA = @Num_Ref_RA
	Else
		Update 
			Caixa_Hou_Exp_Aer 
		Set 
         			Num_Lcto = 'REMESSA',
		         	Dt_Conv_HEA = @Dt_RA, 
         			Dt_Pgto_Rcto_HEA = @Dt_RA
		Where 
			Num_Rcb_HEA = @Num_Ref_RA							

	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 


	Update 
		Caixa_Hou_Exp_Aer 
	Set 
		Par_Moeda_HEA = ((@Tx_Dol_RA * @Tx_Fchto_RA * 100) / 100),
		Vlr_Pgto_Rcto_HEA = ((Vlr_Org_HEA * @Tx_Dol_RA * @Tx_Fchto_RA * 100) / 100)
	From 
		Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cta on (Cxa.Num_Proc_HEA = Cta.Num_Proc_HEA and Cxa.DC_HEA = Cta.DC_HEA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
	Where 
		Cxa.Num_Rcb_HEA = @Num_Ref_RA and
		Cta.Cd_Tp_Moeda = 'USD'


	

	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 


	Update 
		Caixa_Hou_Exp_Aer
	Set 
		Par_Moeda_HEA = ((@Tx_Fchto_RA * @Tx_Conv_RA * 100) / 100),
		Vlr_Pgto_Rcto_HEA = ((Vlr_Org_HEA * @Tx_Conv_RA * @Tx_Fchto_RA * 100) / 100)
	From 
		Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cta on (Cxa.Num_Proc_HEA = Cta.Num_Proc_HEA and Cxa.DC_HEA = Cta.DC_HEA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
	Where 
		Cxa.Num_Rcb_HEA = @Num_Ref_RA and
		Cta.Cd_Tp_Moeda <> 'USD'		

	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 


	Insert into 
		Log_Caixa 
		(Data_Cx, Cd_Usuario,Tp_Oper_Cx, Num_Proc_Cx,Cd_Tp_Tx, DC_Cx, Num_Lcto_Cx, Vlr_Ref, Dt_Conv, Cd_Tp_Par, 
		Par_Moeda_Cx, Vlr_Pgto_Rcto, Dt_Pgto_Rcto_Cx, Num_Rcb)
	Select 
		GetDate(), @Usuario, 'A', Num_Proc_HEA, Cd_Tp_Tx, DC_HEA, Num_Lcto, Vlr_Ref_HEA, Dt_Conv_HEA, Cd_Tp_Par, 
		Par_Moeda_HEA, Vlr_Pgto_Rcto_HEA, Dt_Pgto_Rcto_HEA, Num_Rcb_HEA
	From 
		Caixa_Hou_Exp_Aer 		
	Where 
		Num_Rcb_HEA = @Num_Ref_RA
		
	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 

	Set @VlrDol  = (Select Sum(Vlr_Org_HEA) From Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cta on (Cxa.Num_Proc_HEA = Cta.Num_Proc_HEA and Cxa.DC_HEA = Cta.DC_HEA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEA = @Num_Ref_RA and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HEA = 'D') -  (Select Sum(Vlr_Org_HEA) From Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cta on (Cxa.Num_Proc_HEA = Cta.Num_Proc_HEA and Cxa.DC_HEA = Cta.DC_HEA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEA = @Num_Ref_RA and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HEA = 'C')
	Set @VlrOut = (Select Sum(Vlr_Org_HEA) From Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cta on (Cxa.Num_Proc_HEA = Cta.Num_Proc_HEA and Cxa.DC_HEA = Cta.DC_HEA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEA = @Num_Ref_RA and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HEA = 'D') -  (Select Sum(Vlr_Org_HEA) From Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cta on (Cxa.Num_Proc_HEA = Cta.Num_Proc_HEA and Cxa.DC_HEA = Cta.DC_HEA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEA = @Num_Ref_RA and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HEA = 'C')
	Set @QtdHouse = IsNull((Select Count(Num_Proc_HEA) From Caixa_Hou_Exp_Aer Where Num_Rcb_HEA = @Num_Ref_RA),0) 


	If @Dt_RA = Null or @Dt_RA =''
		Update 
			Caixa_Hou_Imp_Aer 
		Set 
         			Num_Lcto = 'PROVISÓRIO',
		         	Dt_Conv_HIA = @Dt_Oper_RA, 
         			Dt_Pgto_Rcto_HIA = @Dt_Oper_RA
		Where 
			Num_Rcb_HIA = @Num_Ref_RA
	Else
		Update 
			Caixa_Hou_Imp_Aer 
		Set 
         			Num_Lcto = 'REMESSA',
		         	Dt_Conv_HIA = @Dt_RA, 
         			Dt_Pgto_Rcto_HIA = @Dt_RA
		Where 
			Num_Rcb_HIA = @Num_Ref_RA

	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 


	Update 
		Caixa_Hou_Imp_Aer 
	Set 
		Par_Moeda_HIA = ((@Tx_Dol_RA * @Tx_Fchto_RA * 100) / 100),
		Vlr_Pgto_Rcto_HIA = ((Vlr_Org_HIA * @Tx_Dol_RA * @Tx_Fchto_RA * 100) / 100)
	From 
		Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cta on (Cxa.Num_Proc_HIA = Cta.Num_Proc_HIA and Cxa.DC_HIA = Cta.DC_HIA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
	Where 
		Cxa.Num_Rcb_HIA = @Num_Ref_RA and
		Cta.Cd_Tp_Moeda = 'USD'

	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 


	Update 
		Caixa_Hou_Imp_Aer
	Set 
		Par_Moeda_HIA = ((@Tx_Fchto_RA * @Tx_Conv_RA * 100) / 100),
		Vlr_Pgto_Rcto_HIA = ((Vlr_Org_HIA * @Tx_Conv_RA * @Tx_Fchto_RA * 100) / 100)
	From 
		Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cta on (Cxa.Num_Proc_HIA = Cta.Num_Proc_HIA and Cxa.DC_HIA = Cta.DC_HIA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
	Where 
		Cxa.Num_Rcb_HIA = @Num_Ref_RA and
		Cta.Cd_Tp_Moeda <> 'USD'		

	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 

	Insert into 
		Log_Caixa 
		(Data_Cx, Cd_Usuario,Tp_Oper_Cx, Num_Proc_Cx,Cd_Tp_Tx, DC_Cx, Num_Lcto_Cx, Vlr_Ref, Dt_Conv, Cd_Tp_Par, 
		Par_Moeda_Cx, Vlr_Pgto_Rcto, Dt_Pgto_Rcto_Cx, Num_Rcb)
	Select 
		GetDate(), @Usuario, 'A', Num_Proc_HIA, Cd_Tp_Tx, DC_HIA, Num_Lcto, Vlr_Ref_HIA, Dt_Conv_HIA, Cd_Tp_Par, 
		Par_Moeda_HIA, Vlr_Pgto_Rcto_HIA, Dt_Pgto_Rcto_HIA, Num_Rcb_HIA
	From 
		Caixa_Hou_Imp_Aer 		
	Where 
		Num_Rcb_HIA = @Num_Ref_RA
		
	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 

	Set @VlrDol  = @VlrDol + ((Select Sum(Vlr_Org_HIA) From Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cta on (Cxa.Num_Proc_HIA = Cta.Num_Proc_HIA and Cxa.DC_HIA = Cta.DC_HIA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIA = @Num_Ref_RA and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HIA = 'D') -  (Select Sum(Vlr_Org_HIA) From Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cta on (Cxa.Num_Proc_HIA = Cta.Num_Proc_HIA and Cxa.DC_HIA = Cta.DC_HIA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIA = @Num_Ref_RA and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HIA = 'C'))
	Set @VlrOut = @VlrOut + ((Select Sum(Vlr_Org_HIA) From Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cta on (Cxa.Num_Proc_HIA = Cta.Num_Proc_HIA and Cxa.DC_HIA = Cta.DC_HIA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIA = @Num_Ref_RA and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HIA = 'D') -  (Select Sum(Vlr_Org_HIA) From Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cta on (Cxa.Num_Proc_HIA = Cta.Num_Proc_HIA and Cxa.DC_HIA = Cta.DC_HIA and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIA = @Num_Ref_RA and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HIA = 'C'))
	Set @QtdHouse = @QtdHouse + IsNull((Select Count(Num_Proc_HIA) From Caixa_Hou_Imp_Aer Where Num_Rcb_HIA = @Num_Ref_RA),0) 

	Commit Transaction

GO
