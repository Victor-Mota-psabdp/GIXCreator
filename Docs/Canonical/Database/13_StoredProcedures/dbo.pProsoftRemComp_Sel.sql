SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pProsoftRemComp_Sel 
(
@Periodo		VarChar(7),
@ID_Machine		VarChar(30) 
)
AS
	Declare @Dt_Ini		Datetime 
	Declare @Dt_Fim	Datetime 
	Set @Dt_Ini = Convert(Datetime, '01/' + @Periodo, 105) 
	If Left(@Periodo, 2) = '12'
		Set @Dt_Fim = Convert(Datetime, '31/12/' + Cast((Cast(right(@Periodo, 4) as Int) ) as Char(4)), 105) 
	Else
		Set @Dt_Fim = DateAdd(d,  -1, Convert(Datetime, ('01/' + Cast((Cast(Left(@Periodo, 2) as Int) + 1) as VarChar(2))  + Right(@Periodo, 5)), 105))



	Insert Into 
		Tmp_Prosoft 

	Select 
		@ID_Machine, Num_Ref_RA, '', Convert(Datetime, RA.Dt_RA, 105),  'D', 'C', 
		CtaCtbBco.Cd_Cta_Ctb_Red, Vlr_Tot_RA, '', Num_Ref_RA + '-' + Cli.Nome_Raz_Soc
	From 
--		Remessa_Aer as RA Left Outer Join Banco as Bco on (Bco.Cd_Banco = RA.Cd_Banco) 
		Remessa_Aer as RA Left Outer Join Cta_Cte as Cte on (Cte.Cd_Banco = RA.Cd_Banco and Cte.Cd_Agencia = RA.Cd_Agencia and Cte.Num_Cta_Cte = RA.Num_Cta_Cte) 
		Left Outer Join Cta_Ctb as CtaCtbBco on CtaCtbBco.Cd_Cta_Ctb = Cte.Cd_Cta_Ctb 
		Join Pessoa as Cli on Cli.Cd_Pes = RA.Cd_Pes 
	Where
		(Convert(Datetime, RA.Dt_RA, 105) between @Dt_Ini and @Dt_Fim ) and RA.Concil_RA = 'S'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -20
		End 



	Insert Into 
		Tmp_Prosoft 

	Select 
		@ID_Machine, Num_Ref_RM, '', Convert(Datetime, RM.Dt_RM, 105),  'D', 'C', 
		CtaCtbBco.Cd_Cta_Ctb_Red, Vlr_Tot_RM, '', Num_Ref_RM + '-' + Cli.Nome_Raz_Soc
	From 
--		Remessa_Mar as RM Left Outer Join Banco as Bco on (Bco.Cd_Banco = RM.Cd_Banco) 
		Remessa_Mar as RM Left Outer Join Cta_Cte as Cte on (Cte.Cd_Banco = RM.Cd_Banco and Cte.Cd_Agencia = RM.Cd_Agencia and Cte.Num_Cta_Cte = RM.Num_Cta_Cte) 
		Left Outer Join Cta_Ctb as CtaCtbBco on CtaCtbBco.Cd_Cta_Ctb = Cte.Cd_Cta_Ctb 
		Join Pessoa as Cli on Cli.Cd_Pes = RM.Cd_Pes 
	Where
		(Convert(Datetime, RM.Dt_RM, 105) between @Dt_Ini and @Dt_Fim ) and RM.Concil_RM = 'S'




	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -20
		End 


	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, CxaBase.Num_Rcb_HIA,CxaBase.Num_Proc_HIA + CxaBase.Cd_Tp_Tx + CxaBase.DC_HIA, Convert(Datetime, RA.Dt_RA, 105),  'D', CxaBase.DC_HIA, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_HIA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_HIA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_HIA  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIA Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_HIA  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIA Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_HIA  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIA Is Null and CxaBase.DC_HIA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIA Is Null and CxaBase.DC_HIA  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_HIA as Vlr_Lcto, '', CxaBase.Num_Rcb_HIA + ' - ' + TT.Nome_Tp_Tx 
	From 
		Caixa_Hou_Imp_Aer as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Hou_Imp_Aer as CtaInv on (CtaInv.Num_Proc_HIA = CxaBase.Num_Proc_HIA and CtaInv.DC_HIA <> CxaBase.DC_HIA and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Imp_Aer as CxaInv on (CxaInv.Num_Proc_HIA = CxaBase.Num_Proc_HIA and CxaInv.DC_HIA <> CxaBase.DC_HIA and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_HIA, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_HIA, 105)) 
		Join Remessa_Aer as RA on CxaBase.Num_Rcb_HIA = RA.Num_Ref_RA
	Where
		(Convert(Datetime, RA.Dt_RA, 105) between @Dt_Ini and @Dt_Fim ) and RA.Concil_RA = 'S'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 


	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, CxaBase.Num_Rcb_HEA, CxaBase.Num_Proc_HEA + CxaBase.Cd_Tp_Tx + CxaBase.DC_HEA, Convert(Datetime, RA.Dt_RA, 105),  'D', CxaBase.DC_HEA, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_HEA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_HEA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_HEA  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEA Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_HEA  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEA Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_HEA  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEA Is Null and CxaBase.DC_HEA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEA Is Null and CxaBase.DC_HEA  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_HEA as Vlr_Lcto, '', CxaBase.Num_Rcb_HEA + ' - ' + TT.Nome_Tp_Tx 
	From 
		Caixa_Hou_Exp_Aer as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Hou_Exp_Aer as CtaInv on (CtaInv.Num_Proc_HEA = CxaBase.Num_Proc_HEA and CtaInv.DC_HEA <> CxaBase.DC_HEA and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Exp_Aer as CxaInv on (CxaInv.Num_Proc_HEA = CxaBase.Num_Proc_HEA and CxaInv.DC_HEA <> CxaBase.DC_HEA and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_HEA, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_HEA, 105)) 
		Join Remessa_Aer as RA on CxaBase.Num_Rcb_HEA = RA.Num_Ref_RA
	Where
		(Convert(Datetime, RA.Dt_RA, 105) between @Dt_Ini and @Dt_Fim ) and RA.Concil_RA = 'S'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 



	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, CxaBase.Num_Rcb_MIA, CxaBase.Num_Proc_MIA + CxaBase.Cd_Tp_Tx + CxaBase.DC_MIA, Convert(Datetime, RA.Dt_RA, 105),  'D', CxaBase.DC_MIA, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_MIA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_MIA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_MIA  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIA Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_MIA  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIA Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_MIA  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIA Is Null and CxaBase.DC_MIA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIA Is Null and CxaBase.DC_MIA  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_MIA as Vlr_Lcto, '', CxaBase.Num_Rcb_MIA + ' - ' + TT.Nome_Tp_Tx 
	From 
		Caixa_Mas_Imp_Aer as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Mas_Imp_Aer as CtaInv on (CtaInv.Num_Proc_MIA = CxaBase.Num_Proc_MIA and CtaInv.DC_MIA <> CxaBase.DC_MIA and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Imp_Aer as CxaInv on (CxaInv.Num_Proc_MIA = CxaBase.Num_Proc_MIA and CxaInv.DC_MIA <> CxaBase.DC_MIA and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_MIA, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_MIA, 105)) 
		Join Remessa_Aer as RA on CxaBase.Num_Rcb_MIA = RA.Num_Ref_RA
	Where
		(Convert(Datetime, RA.Dt_RA, 105) between @Dt_Ini and @Dt_Fim ) and RA.Concil_RA = 'S'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 

	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, CxaBase.Num_Rcb_MEA, CxaBase.Num_Proc_MEA + CxaBase.Cd_Tp_Tx + CxaBase.DC_MEA, Convert(Datetime, RA.Dt_RA, 105),  'D', CxaBase.DC_MEA, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_MEA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_MEA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_MEA  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEA Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_MEA  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEA Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_MEA  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEA Is Null and CxaBase.DC_MEA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEA Is Null and CxaBase.DC_MEA  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_MEA as Vlr_Lcto, '', CxaBase.Num_Rcb_MEA + ' - ' + TT.Nome_Tp_Tx 
	From 
		Caixa_Mas_Exp_Aer as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Mas_Exp_Aer as CtaInv on (CtaInv.Num_Proc_MEA = CxaBase.Num_Proc_MEA and CtaInv.DC_MEA <> CxaBase.DC_MEA and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Exp_Aer as CxaInv on (CxaInv.Num_Proc_MEA = CxaBase.Num_Proc_MEA and CxaInv.DC_MEA <> CxaBase.DC_MEA and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_MEA, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_MEA, 105)) 
		Join Remessa_Aer as RA on CxaBase.Num_Rcb_MEA = RA.Num_Ref_RA
	Where
		(Convert(Datetime, RA.Dt_RA, 105) between @Dt_Ini and @Dt_Fim ) and RA.Concil_RA = 'S'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End


	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, CxaBase.Num_Rcb_HIM, CxaBase.Num_Proc_HIM + CxaBase.Cd_Tp_Tx + CxaBase.DC_HIM, Convert(Datetime, RM.Dt_RM, 105),  'D', CxaBase.DC_HIM, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_HIM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_HIM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_HIM  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIM Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_HIM  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIM Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_HIM  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIM Is Null and CxaBase.DC_HIM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIM Is Null and CxaBase.DC_HIM  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_HIM as Vlr_Lcto, '', CxaBase.Num_Rcb_HIM + ' - ' + TT.Nome_Tp_Tx 
	From 
		Caixa_Hou_Imp_Mar as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Hou_Imp_Mar as CtaInv on (CtaInv.Num_Proc_HIM = CxaBase.Num_Proc_HIM and CtaInv.DC_HIM <> CxaBase.DC_HIM and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Imp_Mar as CxaInv on (CxaInv.Num_Proc_HIM = CxaBase.Num_Proc_HIM and CxaInv.DC_HIM <> CxaBase.DC_HIM and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_HIM, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_HIM, 105)) 
		Join Remessa_Mar as RM on CxaBase.Num_Rcb_HIM = RM.Num_Ref_RM 
	Where
		(Convert(Datetime, RM.Dt_RM, 105) between @Dt_Ini and @Dt_Fim ) and RM.Concil_RM = 'S'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 

	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, CxaBase.Num_Rcb_HEM, CxaBase.Num_Proc_HEM + CxaBase.Cd_Tp_Tx + CxaBase.DC_HEM, Convert(Datetime, RM.Dt_RM, 105), 'D', CxaBase.DC_HEM, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_HEM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_HEM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_HEM  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEM Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_HEM  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEM Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_HEM  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEM Is Null and CxaBase.DC_HEM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEM Is Null and CxaBase.DC_HEM  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_HEM as Vlr_Lcto, '', CxaBase.Num_Rcb_HEM + ' - ' + TT.Nome_Tp_Tx 
	From 
		Caixa_Hou_Exp_Mar as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Hou_Exp_Mar as CtaInv on (CtaInv.Num_Proc_HEM = CxaBase.Num_Proc_HEM and CtaInv.DC_HEM <> CxaBase.DC_HEM and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Exp_Mar as CxaInv on (CxaInv.Num_Proc_HEM = CxaBase.Num_Proc_HEM and CxaInv.DC_HEM <> CxaBase.DC_HEM and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_HEM, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_HEM, 105)) 
		Join Remessa_Mar as RM on CxaBase.Num_Rcb_HEM = RM.Num_Ref_RM 
	Where
		(Convert(Datetime, RM.Dt_RM, 105) between @Dt_Ini and @Dt_Fim ) and RM.Concil_RM = 'S'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 


	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, CxaBase.Num_Rcb_MIM,CxaBase.Num_Proc_MIM + CxaBase.Cd_Tp_Tx + CxaBase.DC_MIM, Convert(Datetime, RM.Dt_RM, 105), 'D', CxaBase.DC_MIM, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_MIM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_MIM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_MIM  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIM Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_MIM  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIM Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_MIM  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIM Is Null and CxaBase.DC_MIM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIM Is Null and CxaBase.DC_MIM  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_MIM as Vlr_Lcto, '', CxaBase.Num_Rcb_MIM + ' - ' + TT.Nome_Tp_Tx 
	From 
		Caixa_Mas_Imp_Mar as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Mas_Imp_Mar as CtaInv on (CtaInv.Num_Proc_MIM = CxaBase.Num_Proc_MIM and CtaInv.DC_MIM <> CxaBase.DC_MIM and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Imp_Mar as CxaInv on (CxaInv.Num_Proc_MIM = CxaBase.Num_Proc_MIM and CxaInv.DC_MIM <> CxaBase.DC_MIM and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_MIM, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_MIM, 105)) 
		Join Remessa_Mar as RM on CxaBase.Num_Rcb_MIM = RM.Num_Ref_RM
	Where
		(Convert(Datetime, RM.Dt_RM, 105) between @Dt_Ini and @Dt_Fim ) and RM.Concil_RM = 'S'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 


	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, CxaBase.Num_Rcb_MEM, CxaBase.Num_Proc_MEM + CxaBase.Cd_Tp_Tx + CxaBase.DC_MEM, Convert(Datetime, RM.Dt_RM, 105), 'D', CxaBase.DC_MEM, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_MEM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_MEM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CxaBase.DC_MEM  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEM Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_MEM  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEM Is Not Null and CxaInv.Num_Lcto Is Null  and CxaBase.DC_MEM  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEM Is Null and CxaBase.DC_MEM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEM Is Null and CxaBase.DC_MEM  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_MEM as Vlr_Lcto, '', CxaBase.Num_Rcb_MEM + ' - ' + TT.Nome_Tp_Tx 
	From 
		Caixa_Mas_Exp_Mar as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Mas_Exp_Mar as CtaInv on (CtaInv.Num_Proc_MEM = CxaBase.Num_Proc_MEM and CtaInv.DC_MEM <> CxaBase.DC_MEM and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Exp_Mar as CxaInv on (CxaInv.Num_Proc_MEM = CxaBase.Num_Proc_MEM and CxaInv.DC_MEM <> CxaBase.DC_MEM and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_MEM, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_MEM, 105)) 
		Join Remessa_Mar as RM on CxaBase.Num_Rcb_MEM = RM.Num_Ref_RM
	Where
		(Convert(Datetime, RM.Dt_RM, 105) between @Dt_Ini and @Dt_Fim ) and RM.Concil_RM = 'S'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 
	Else
		Begin 
			--Commit Transaction 
			Return 1
		End

GO
