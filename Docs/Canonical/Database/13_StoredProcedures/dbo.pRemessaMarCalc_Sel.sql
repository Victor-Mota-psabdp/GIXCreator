SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pRemessaMarCalc_Sel 
(
@Num_Ref_RM		VarChar(12), 
@Dt_Oper_RM		VarChar(10), 
@Dt_RM 		VarChar(10),
@Tx_Dol_RM 		Float, 
@Tx_Conv_RM 		Float, 
@Tx_Fchto_RM		Float,
@Usuario		VarChar(10), 
@QtdHouse		Int=Null OUTPUT, 
@VlrDol			Float=Null OUTPUT,
@VlrOut		Float=Null OUTPUT
)
AS
	Begin Transaction 
	If @Dt_RM = Null or @Dt_RM =''
		Update 
			Caixa_Hou_Exp_Mar
		Set 
         			Num_Lcto = 'PROVISÓRIO',
		         	Dt_Conv_HEM = @Dt_Oper_RM, 
         			Dt_Pgto_Rcto_HEM = @Dt_Oper_RM
		Where 
			Num_Rcb_HEM = @Num_Ref_RM
	Else
		Update 
			Caixa_Hou_Exp_Mar
		Set 
         			Num_Lcto = 'REMESSA',
		         	Dt_Conv_HEM = @Dt_RM, 
         			Dt_Pgto_Rcto_HEM = @Dt_RM
		Where 
			Num_Rcb_HEM = @Num_Ref_RM							

	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 


	Update 
		Caixa_Hou_Exp_Mar
	Set 
		Par_Moeda_HEM = ((@Tx_Dol_RM * @Tx_Fchto_RM * 100) / 100),
		Vlr_Pgto_Rcto_HEM = ((Vlr_Org_HEM * @Tx_Dol_RM * @Tx_Fchto_RM * 100) / 100)
	From 
		Caixa_Hou_Exp_Mar as Cxa Join Cta_Cte_Hou_Exp_Mar as Cta on (Cxa.Num_Proc_HEM = Cta.Num_Proc_HEM and Cxa.DC_HEM = Cta.DC_HEM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
	Where 
		Cxa.Num_Rcb_HEM = @Num_Ref_RM and
		Cta.Cd_Tp_Moeda = 'USD'
	

	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 


	Update 
		Caixa_Hou_Exp_Mar
	Set 
		Par_Moeda_HEM = ((@Tx_Fchto_RM * @Tx_Conv_RM * 100) / 100),
		Vlr_Pgto_Rcto_HEM = ((Vlr_Org_HEM * @Tx_Conv_RM * @Tx_Fchto_RM * 100) / 100)
	From 
		Caixa_Hou_Exp_Mar as Cxa Join Cta_Cte_Hou_Exp_Mar as Cta on (Cxa.Num_Proc_HEM = Cta.Num_Proc_HEM and Cxa.DC_HEM = Cta.DC_HEM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
	Where 
		Cxa.Num_Rcb_HEM = @Num_Ref_RM and
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
		GetDate(), @Usuario, 'A', Num_Proc_HEM, Cd_Tp_Tx, DC_HEM, Num_Lcto, Vlr_Ref_HEM, Dt_Conv_HEM, Cd_Tp_Par, 
		Par_Moeda_HEM, Vlr_Pgto_Rcto_HEM, Dt_Pgto_Rcto_HEM, Num_Rcb_HEM
	From 
		Caixa_Hou_Exp_Mar
	Where 
		Num_Rcb_HEM = @Num_Ref_RM
		
	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 

	Set @VlrDol  = (Select Sum(Vlr_Org_HEM) From Caixa_Hou_Exp_Mar as Cxa Join Cta_Cte_Hou_Exp_Mar as Cta on (Cxa.Num_Proc_HEM = Cta.Num_Proc_HEM and Cxa.DC_HEM = Cta.DC_HEM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEM = @Num_Ref_RM and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HEM = 'D') -  (Select Sum(Vlr_Org_HEM) From 	Caixa_Hou_Exp_Mar as Cxa Join Cta_Cte_Hou_Exp_Mar as Cta on (Cxa.Num_Proc_HEM = Cta.Num_Proc_HEM and Cxa.DC_HEM = Cta.DC_HEM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEM = @Num_Ref_RM and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HEM = 'C')
	Set @VlrOut = (Select Sum(Vlr_Org_HEM) From Caixa_Hou_Exp_Mar as Cxa Join Cta_Cte_Hou_Exp_Mar as Cta on (Cxa.Num_Proc_HEM = Cta.Num_Proc_HEM and Cxa.DC_HEM = Cta.DC_HEM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEM = @Num_Ref_RM and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HEM = 'D') -  (Select Sum(Vlr_Org_HEM) From 	Caixa_Hou_Exp_Mar as Cxa Join Cta_Cte_Hou_Exp_Mar as Cta on (Cxa.Num_Proc_HEM = Cta.Num_Proc_HEM and Cxa.DC_HEM = Cta.DC_HEM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)	Where 	Cxa.Num_Rcb_HEM = @Num_Ref_RM and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HEM = 'C')
	Set @QtdHouse = IsNull((Select Count(Num_Proc_HEM) From Caixa_Hou_Exp_Mar Where Num_Rcb_HEM = @Num_Ref_RM),0) 


	If @Dt_RM = Null or @Dt_RM =''
		Update 
			Caixa_Hou_Imp_Mar
		Set 
         			Num_Lcto = 'PROVISÓRIO',
		         	Dt_Conv_HIM = @Dt_Oper_RM, 
         			Dt_Pgto_Rcto_HIM = @Dt_Oper_RM
		Where 
			Num_Rcb_HIM = @Num_Ref_RM
	Else
		Update 
			Caixa_Hou_Imp_Mar
		Set 
         			Num_Lcto = 'REMESSA',
		         	Dt_Conv_HIM = @Dt_RM, 
         			Dt_Pgto_Rcto_HIM = @Dt_RM
		Where 
			Num_Rcb_HIM = @Num_Ref_RM

	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 


	Update 
		Caixa_Hou_Imp_Mar
	Set 
		Par_Moeda_HIM = ((@Tx_Dol_RM * @Tx_Fchto_RM * 100) / 100),
		Vlr_Pgto_Rcto_HIM = ((Vlr_Org_HIM * @Tx_Dol_RM * @Tx_Fchto_RM * 100) / 100)
	From 
		Caixa_Hou_Imp_Mar as Cxa Join Cta_Cte_Hou_Imp_Mar as Cta on (Cxa.Num_Proc_HIM = Cta.Num_Proc_HIM and Cxa.DC_HIM = Cta.DC_HIM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
	Where 
		Cxa.Num_Rcb_HIM = @Num_Ref_RM and
		Cta.Cd_Tp_Moeda = 'USD'

	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 


	Update 
		Caixa_Hou_Imp_Mar
	Set 
		Par_Moeda_HIM = ((@Tx_Fchto_RM * @Tx_Conv_RM * 100) / 100),
		Vlr_Pgto_Rcto_HIM = ((Vlr_Org_HIM * @Tx_Conv_RM * @Tx_Fchto_RM * 100) / 100)
	From 
		Caixa_Hou_Imp_Mar as Cxa Join Cta_Cte_Hou_Imp_Mar as Cta on (Cxa.Num_Proc_HIM = Cta.Num_Proc_HIM and Cxa.DC_HIM = Cta.DC_HIM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx)
	Where 
		Cxa.Num_Rcb_HIM = @Num_Ref_RM and
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
		GetDate(), @Usuario, 'A', Num_Proc_HIM, Cd_Tp_Tx, DC_HIM, Num_Lcto, Vlr_Ref_HIM, Dt_Conv_HIM, Cd_Tp_Par, 
		Par_Moeda_HIM, Vlr_Pgto_Rcto_HIM, Dt_Pgto_Rcto_HIM, Num_Rcb_HIM
	From 
		Caixa_Hou_Imp_Mar
	Where 
		Num_Rcb_HIM = @Num_Ref_RM
		
	If @@Error <> 0 
		Begin 
			RollBack Transaction
			Return -1 
		End 

	Set @VlrDol  = @VlrDol + ((Select Sum(Vlr_Org_HIM) From Caixa_Hou_Imp_Mar as Cxa Join Cta_Cte_Hou_Imp_Mar as Cta on (Cxa.Num_Proc_HIM = Cta.Num_Proc_HIM and Cxa.DC_HIM = Cta.DC_HIM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIM = @Num_Ref_RM and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HIM = 'D') -  (Select Sum(Vlr_Org_HIM) From Caixa_Hou_Imp_Mar as Cxa Join Cta_Cte_Hou_Imp_Mar as Cta on (Cxa.Num_Proc_HIM = Cta.Num_Proc_HIM and Cxa.DC_HIM = Cta.DC_HIM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIM = @Num_Ref_RM and Cta.Cd_Tp_Moeda = 'USD' and Cta.DC_HIM = 'C'))
	Set @VlrOut = @VlrOut + ((Select Sum(Vlr_Org_HIM) From 	Caixa_Hou_Imp_Mar as Cxa Join Cta_Cte_Hou_Imp_Mar as Cta on (Cxa.Num_Proc_HIM = Cta.Num_Proc_HIM and Cxa.DC_HIM = Cta.DC_HIM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIM = @Num_Ref_RM and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HIM = 'D') -  (Select Sum(Vlr_Org_HIM) From Caixa_Hou_Imp_Mar as Cxa Join Cta_Cte_Hou_Imp_Mar as Cta on (Cxa.Num_Proc_HIM = Cta.Num_Proc_HIM and Cxa.DC_HIM = Cta.DC_HIM and Cxa.Cd_Tp_Tx = Cta.Cd_Tp_Tx) Where Cxa.Num_Rcb_HIM = @Num_Ref_RM and Cta.Cd_Tp_Moeda <> 'USD' and Cta.DC_HIM = 'C'))
	Set @QtdHouse = @QtdHouse + IsNull((Select Count(Num_Proc_HIM) From Caixa_Hou_Imp_Mar Where Num_Rcb_HIM = @Num_Ref_RM),0) 
	Commit Transaction

GO
