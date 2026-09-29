SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pProsoftPgtRctComp_Sel 
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


	--Begin Transaction 

	Insert Into 
		Tmp_Prosoft 

	Select 
		@ID_Machine, Num_Lcto, Num_Doc, Convert(Datetime, PR.Dt_Pgto_Rcto, 105),  PR.DC, DC =
		Case 
			When PR.DC = 'C' then 'D'
			Else 'C'
		End, 
		CtaCtbBco.Cd_Cta_Ctb_Red, Vlr_Doc, '', Cli.Nome_Raz_Soc + ' ' + Num_Doc + ' (' + Forma_Pgto_Rcto + ' )' 
	From 
--		Pgto_Rcto as PR Left Outer Join Banco as Bco on (Bco.Cd_Banco = PR.Cd_Banco) 
		Pgto_Rcto as PR Left Outer Join Cta_Cte as Cte on (Cte.Cd_Banco = PR.Cd_Banco and Cte.Cd_Agencia = PR.Cd_Agencia and Cte.Num_Cta_Cte = PR.Num_Cta_Cte) 
		Left Outer Join Cta_Ctb as CtaCtbBco on CtaCtbBco.Cd_Cta_Ctb = Cte.Cd_Cta_Ctb 
		Join Pessoa as Cli on Cli.Cd_Pes = PR.Cd_Pes 
	Where
		(Convert(Datetime, PR.Dt_Pgto_Rcto, 105) between @Dt_Ini and @Dt_Fim ) and PR.Concil = 'S'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -20
		End 

	--DAs 
	Insert Into 
		Tmp_Prosoft 

	Select 
		@ID_Machine,Num_Lcto_Div, Num_Lcto_Div, Convert(Datetime,Dt_Pgto_Rcto_Div, 105), DC_Div, 
		Dc_Tax = 
		Case 
			When DC_Div = 'C' then 'D'
			Else 'C'
		End,
		CCt.Cd_Cta_Ctb_Red, Vlr_Doc_Div, '', Num_Doc_Div + '  ('  + PRD.Num_Lcto_Div + ') - ' + Cli.Nome_Raz_Soc 
	From 
		Pgto_Rcto_Div as PRD Join Cta_Cte as CC on (CC.Cd_Banco =PRD.Cd_Banco and CC.Cd_Agencia = PRD.Cd_Agencia and CC.Num_Cta_Cte = PRD.Num_Cta_Cte) 
		Join Pessoa as Cli on Cli.Cd_Pes = PRD.Cd_Pes 
		Join Cta_Ctb as CCt on CCt.Cd_Cta_Ctb = CC.Cd_Cta_Ctb  

	Where 
		(Convert(Datetime, Dt_Pgto_Rcto_Div, 105) between @Dt_Ini and @Dt_Fim)  and PRD.Concil_Div = 'S'

--		and PRD.Num_Lcto_Div Not In (Select  	Distinct PRD1.Num_Lcto_Div From Pgto_Rcto_Div as PRD1 Join pgto_rcto_div_det as PRDD1 on PRDD1.Num_Lcto_Div = PRD1.Num_Lcto_Div Join Cta_Ctb as CC1 on CC1.Cd_Cta_Ctb = PRDD1.Cd_Cta_Ctb Where PRD1.DC_Div = 'D' and (Convert(Datetime, PRD1.Dt_Pgto_Rcto_Div, 105) between @Dt_Ini and @Dt_Fim) and CC1.Ck_Ativo = 'N')

	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -20
		End 

	Insert Into 
		Tmp_Prosoft 

	Select  
		@ID_Machine,PRDD.Num_Lcto_Div, PRDD.Num_Lcto_Div, Convert(Datetime,PRD.Dt_Pgto_Rcto_Div, 105), PRD.DC_Div, 
		DC_Item, CC.Cd_Cta_Ctb_Red, PRDD.Vlr_Item, Cd_Centro_Custo, Num_Doc_Div + ' (' + PRD.Num_Lcto_Div + ') - ' + Cli.Nome_Raz_Soc 
	From 
		Pgto_Rcto_Div as PRD Join Pgto_Rcto_Div_Det as PRDD on PRDD.Num_Lcto_Div = PRD.Num_Lcto_Div 
		Join Pessoa as Cli on Cli.Cd_Pes = PRD.Cd_Pes 
		Join Cta_Ctb as CC on CC.Cd_Cta_Ctb = PRDD.Cd_Cta_Ctb
	Where 
		(Convert(Datetime, PRD.Dt_Pgto_Rcto_Div, 105) between @Dt_Ini and @Dt_Fim) 
		and PRD.Concil_Div = 'S'
--		and PRD.Num_Lcto_Div Not In (Select  	Distinct PRD1.Num_Lcto_Div From Pgto_Rcto_Div as PRD1 Join pgto_rcto_div_det as PRDD1 on PRDD1.Num_Lcto_Div = PRD1.Num_Lcto_Div Join Cta_Ctb as CC1 on CC1.Cd_Cta_Ctb = PRDD1.Cd_Cta_Ctb Where PRD1.DC_Div = 'D' and (Convert(Datetime, PRD1.Dt_Pgto_Rcto_Div, 105) between @Dt_Ini and @Dt_Fim) and CC1.Ck_Ativo = 'N')


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -20
		End 


	--Item de Pgtos. Rctos.	

	Insert Into 
		Tmp_Prosoft 
	Select Distinct 
		@ID_Machine, CxaBase.Num_Lcto, 'PROV', Convert(Datetime, PR.Dt_Pgto_Rcto, 105),  PR.DC, CxaBase.DC_HIM, 
		Cta_Ctb = 
		Case 
			When ((CtaInv.Num_Proc_HIM Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaMInv.Num_Proc_MIM Is Not Null and CxaMInv.Num_Lcto Is Not Null))  and CxaBase.DC_HIM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_HIM Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaMInv.Num_Proc_MIM Is Not Null and CxaMInv.Num_Lcto Is Not Null))  and CxaBase.DC_HIM  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_HIM Is Not Null and CxaInv.Num_Lcto Is Null)  or (CtaMInv.Num_Proc_MIM Is Not Null and CxaMInv.Num_Lcto Is Null)) and CxaBase.DC_HIM  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_HIM Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaMInv.Num_Proc_MIM Is Not Null and CxaMInv.Num_Lcto Is Null))  and CxaBase.DC_HIM  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIM Is Null and CtaMInv.Num_Proc_MIM Is Null and CxaBase.DC_HIM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIM Is Null and CtaMInv.Num_Proc_MIM Is Null  and CxaBase.DC_HIM  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_HIM as Vlr_Lcto, '', CxaBase.Num_Lcto + ' - ' + CxaBase.Num_Proc_HIM + '-' + TT.Nome_Tp_Tx 
	From 
		Caixa_Hou_Imp_Mar as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Hou_Imp_Mar as CtaInv on (CtaInv.Num_Proc_HIM = CxaBase.Num_Proc_HIM and CtaInv.DC_HIM <> CxaBase.DC_HIM and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Imp_Mar as CxaInv on (CxaInv.Num_Proc_HIM = CxaBase.Num_Proc_HIM and CxaInv.DC_HIM <> CxaBase.DC_HIM and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_HIM, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_HIM, 105) and CxaInv.Num_Lcto <> 'PROVISÓRIO') 

		Left Outer Join Cta_Cte_Mas_Imp_Mar as CtaMInv on (CtaMInv.Num_Proc_MIM = Left(CxaBase.Num_Proc_HIM, 14) and CtaMInv.DC_MIM <> CxaBase.DC_HIM and CtaMInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Imp_Mar as CxaMInv on (CxaMInv.Num_Proc_MIM = Left(CxaBase.Num_Proc_HIM, 14) and CxaMInv.DC_MIM <> CxaBase.DC_HIM and CxaMInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaMInv.Dt_Pgto_Rcto_MIM, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_HIM, 105) and CxaMInv.Num_Lcto <> 'PROVISÓRIO') 

		Join Pgto_Rcto as PR on CxaBase.Num_Lcto = PR.Num_Lcto
	Where
		(Convert(Datetime, PR.Dt_Pgto_Rcto, 105) between @Dt_Ini and @Dt_Fim ) and PR.Concil = 'S' and 
		CxaBase.Num_Lcto <> 'PROVISÓRIO'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 


	Insert Into 
		Tmp_Prosoft 
	Select Distinct 
		@ID_Machine, CxaBase.Num_Lcto, 'PROV', Convert(Datetime, PR.Dt_Pgto_Rcto, 105),  PR.DC, CxaBase.DC_HIA, 
		Cta_Ctb = 
		Case 
			When ((CtaInv.Num_Proc_HIA Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaMInv.Num_Proc_MIA Is Not Null and CxaMInv.Num_Lcto Is Not Null))  and CxaBase.DC_HIA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_HIA Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaMInv.Num_Proc_MIA Is Not Null and CxaMInv.Num_Lcto Is Not Null))  and CxaBase.DC_HIA  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_HIA Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaMInv.Num_Proc_MIA Is Not Null and CxaMInv.Num_Lcto Is Null))  and CxaBase.DC_HIA  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_HIA Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaMInv.Num_Proc_MIA Is Not Null and CxaMInv.Num_Lcto Is Null))  and CxaBase.DC_HIA  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIA Is Null and CtaMInv.Num_Proc_MIA Is Null and CxaBase.DC_HIA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIA Is Null and CtaMInv.Num_Proc_MIA Is Null and CxaBase.DC_HIA  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_HIA as Vlr_Lcto, '', CxaBase.Num_Lcto + ' - ' + CxaBase.Num_Proc_HIA + '-' + TT.Nome_Tp_Tx 
	From 
		Caixa_Hou_Imp_Aer as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Hou_Imp_Aer as CtaInv on (CtaInv.Num_Proc_HIA = CxaBase.Num_Proc_HIA and CtaInv.DC_HIA <> CxaBase.DC_HIA and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Imp_Aer as CxaInv on (CxaInv.Num_Proc_HIA = CxaBase.Num_Proc_HIA and CxaInv.DC_HIA <> CxaBase.DC_HIA and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_HIA, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_HIA, 105) and CxaInv.Num_Lcto <> 'PROVISÓRIO') 

		Left Outer Join Cta_Cte_Mas_Imp_Aer as CtaMInv on (CtaMInv.Num_Proc_MIA = Left(CxaBase.Num_Proc_HIA, 14) and CtaMInv.DC_MIA <> CxaBase.DC_HIA and CtaMInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Imp_Aer as CxaMInv on (CxaMInv.Num_Proc_MIA = Left(CxaBase.Num_Proc_HIA, 14) and CxaMInv.DC_MIA <> CxaBase.DC_HIA and CxaMInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaMInv.Dt_Pgto_Rcto_MIA, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_HIA, 105) and CxaMInv.Num_Lcto <> 'PROVISÓRIO') 

		Join Pgto_Rcto as PR on CxaBase.Num_Lcto = PR.Num_Lcto
	Where
		(Convert(Datetime, PR.Dt_Pgto_Rcto, 105) between @Dt_Ini and @Dt_Fim ) and PR.Concil = 'S' and 
		CxaBase.Num_Lcto <> 'PROVISÓRIO'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 

	Insert Into 
		Tmp_Prosoft 
	Select Distinct 
		@ID_Machine, CxaBase.Num_Lcto, 'PROV', Convert(Datetime, PR.Dt_Pgto_Rcto, 105),  PR.DC, CxaBase.DC_HEM, 
		Cta_Ctb = 
		Case 
			When ((CtaInv.Num_Proc_HEM Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaMInv.Num_Proc_MEM Is Not Null and CxaMInv.Num_Lcto Is Not Null))  and CxaBase.DC_HEM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_HEM Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaMInv.Num_Proc_MEM Is Not Null and CxaMInv.Num_Lcto Is Not Null))  and CxaBase.DC_HEM  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_HEM Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaMInv.Num_Proc_MEM Is Not Null and CxaMInv.Num_Lcto Is Null))  and CxaBase.DC_HEM  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_HEM Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaMInv.Num_Proc_MEM Is Not Null and CxaMInv.Num_Lcto Is Null))  and CxaBase.DC_HEM  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEM Is Null and CtaMInv.Num_Proc_MEM Is Null and CxaBase.DC_HEM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEM Is Null and CtaMInv.Num_Proc_MEM Is Null  and CxaBase.DC_HEM  = 'D' then CCPas.Cd_Cta_Ctb_Red 		End, 
		CxaBase.Vlr_Pgto_Rcto_HEM as Vlr_Lcto, '', CxaBase.Num_Lcto + ' - ' + CxaBase.Num_Proc_HEM + '-' +  TT.Nome_Tp_Tx 
	From 
		Caixa_Hou_Exp_Mar as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Hou_Exp_Mar as CtaInv on (CtaInv.Num_Proc_HEM = CxaBase.Num_Proc_HEM and CtaInv.DC_HEM <> CxaBase.DC_HEM and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Exp_Mar as CxaInv on (CxaInv.Num_Proc_HEM = CxaBase.Num_Proc_HEM and CxaInv.DC_HEM <> CxaBase.DC_HEM and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_HEM, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_HEM, 105) and CxaInv.Num_Lcto <> 'PROVISÓRIO') 

		Left Outer Join Cta_Cte_Mas_Exp_Mar as CtaMInv on (CtaMInv.Num_Proc_MEM = Left(CxaBase.Num_Proc_HEM, 14) and CtaMInv.DC_MEM <> CxaBase.DC_HEM and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Exp_Mar as CxaMInv on (CxaMInv.Num_Proc_MEM = Left(CxaBase.Num_Proc_HEM, 14) and CxaMInv.DC_MEM <> CxaBase.DC_HEM and CxaMInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaMInv.Dt_Pgto_Rcto_MEM, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_HEM, 105) and CxaMInv.Num_Lcto <> 'PROVISÓRIO') 

		Join Pgto_Rcto as PR on CxaBase.Num_Lcto = PR.Num_Lcto
	Where
		(Convert(Datetime, PR.Dt_Pgto_Rcto, 105) between @Dt_Ini and @Dt_Fim ) and PR.Concil = 'S' and 
		CxaBase.Num_Lcto <> 'PROVISÓRIO'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 

	Insert Into 
		Tmp_Prosoft 
	Select Distinct 
		@ID_Machine, CxaBase.Num_Lcto, 'PROV', Convert(Datetime, PR.Dt_Pgto_Rcto, 105),  PR.DC, CxaBase.DC_HEA, 
		Cta_Ctb = 
		Case 
			When ((CtaInv.Num_Proc_HEA Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaMInv.Num_Proc_MEA Is Not Null and CxaMInv.Num_Lcto Is Not Null))   and CxaBase.DC_HEA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_HEA Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaMInv.Num_Proc_MEA Is Not Null and CxaMInv.Num_Lcto Is Not Null))   and CxaBase.DC_HEA  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_HEA Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaMInv.Num_Proc_MEA Is Not Null and CxaMInv.Num_Lcto Is Null ))  and CxaBase.DC_HEA  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_HEA Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaMInv.Num_Proc_MEA Is Not Null and CxaMInv.Num_Lcto Is Null ))  and CxaBase.DC_HEA  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEA Is Null and CtaMInv.Num_Proc_MEA Is Null  and CxaBase.DC_HEA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEA Is Null and CtaMInv.Num_Proc_MEA Is Null and CxaBase.DC_HEA  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_HEA as Vlr_Lcto, '', CxaBase.Num_Lcto + ' - ' + CxaBase.Num_Proc_HEA + '-' +  TT.Nome_Tp_Tx 
	From 
		Caixa_Hou_Exp_Aer as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Hou_Exp_Aer as CtaInv on (CtaInv.Num_Proc_HEA = CxaBase.Num_Proc_HEA and CtaInv.DC_HEA <> CxaBase.DC_HEA and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Exp_Aer as CxaInv on (CxaInv.Num_Proc_HEA = CxaBase.Num_Proc_HEA and CxaInv.DC_HEA <> CxaBase.DC_HEA and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_HEA, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_HEA, 105) and CxaInv.Num_Lcto <> 'PROVISÓRIO') 

		Left Outer Join Cta_Cte_Mas_Exp_Aer as CtaMInv on (CtaMInv.Num_Proc_MEA = Left(CxaBase.Num_Proc_HEA, 14) and CtaMInv.DC_MEA <> CxaBase.DC_HEA and CtaMInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Exp_Aer as CxaMInv on (CxaMInv.Num_Proc_MEA = Left(CxaBase.Num_Proc_HEA, 14) and CxaMInv.DC_MEA <> CxaBase.DC_HEA and CxaMInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxamInv.Dt_Pgto_Rcto_MEA, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_HEA, 105) and CxaMInv.Num_Lcto <> 'PROVISÓRIO') 

		Join Pgto_Rcto as PR on CxaBase.Num_Lcto = PR.Num_Lcto
	Where
		(Convert(Datetime, PR.Dt_Pgto_Rcto, 105) between @Dt_Ini and @Dt_Fim ) and PR.Concil = 'S' and 
		CxaBase.Num_Lcto <> 'PROVISÓRIO'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 


	Insert Into 
		Tmp_Prosoft 
	Select Distinct 
		@ID_Machine, CxaBase.Num_Lcto, 'PROV', Convert(Datetime, PR.Dt_Pgto_Rcto, 105),  PR.DC, CxaBase.DC_MIM, 
		Cta_Ctb = 
		Case 
			When ((CtaInv.Num_Proc_MIM Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaHInv.Num_Proc_HIM Is Not Null and CxaHInv.Num_Lcto Is Not Null ))  and CxaBase.DC_MIM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_MIM Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaHInv.Num_Proc_HIM Is Not Null and CxaHInv.Num_Lcto Is Not Null ))  and CxaBase.DC_MIM  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_MIM Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaHInv.Num_Proc_HIM Is Not Null and CxaHInv.Num_Lcto Is Null ))  and CxaBase.DC_MIM  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_MIM Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaHInv.Num_Proc_HIM Is Not Null and CxaHInv.Num_Lcto Is Null))  and CxaBase.DC_MIM  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIM Is Null and CtaHInv.Num_Proc_HIM Is Null and  CxaBase.DC_MIM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIM Is Null and CtaHInv.Num_Proc_HIM Is Null and  CxaBase.DC_MIM  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_MIM as Vlr_Lcto, '', CxaBase.Num_Lcto + ' - ' + CxaBase.Num_Proc_MIM + '  -' +  TT.Nome_Tp_Tx 
	From 
		Caixa_Mas_Imp_Mar as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Mas_Imp_Mar as CtaInv on (CtaInv.Num_Proc_MIM = CxaBase.Num_Proc_MIM and CtaInv.DC_MIM <> CxaBase.DC_MIM and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Imp_Mar as CxaInv on (CxaInv.Num_Proc_MIM = CxaBase.Num_Proc_MIM and CxaInv.DC_MIM <> CxaBase.DC_MIM and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_MIM, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_MIM, 105) and CxaInv.Num_Lcto <> 'PROVISÓRIO') 

		Left Outer Join Cta_Cte_Hou_Imp_Mar as CtaHInv on (Left(CtaHInv.Num_Proc_HIM, 14) = CxaBase.Num_Proc_MIM and CtaHInv.DC_HIM <> CxaBase.DC_MIM and CtaHInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Imp_Mar as CxaHInv on (Left(CxaHInv.Num_Proc_HIM, 14) = CxaBase.Num_Proc_MIM and CxaHInv.DC_HIM <> CxaBase.DC_MIM and CxaHInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaHInv.Dt_Pgto_Rcto_HIM, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_MIM, 105) and CxaHInv.Num_Lcto <> 'PROVISÓRIO') 

		Join Pgto_Rcto as PR on CxaBase.Num_Lcto = PR.Num_Lcto
	Where
		(Convert(Datetime, PR.Dt_Pgto_Rcto, 105) between @Dt_Ini and @Dt_Fim ) and PR.Concil = 'S' and 
		CxaBase.Num_Lcto <> 'PROVISÓRIO'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 


	Insert Into 
		Tmp_Prosoft 
	Select Distinct 
		@ID_Machine, CxaBase.Num_Lcto, 'PROV', Convert(Datetime, PR.Dt_Pgto_Rcto, 105),  PR.DC, CxaBase.DC_MIA, 
		Cta_Ctb = 
		Case 
			When ((CtaInv.Num_Proc_MIA Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaHInv.Num_Proc_HIA Is Not Null and CxaHInv.Num_Lcto Is Not Null))  and CxaBase.DC_MIA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_MIA Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaHInv.Num_Proc_HIA Is Not Null and CxaHInv.Num_Lcto Is Not Null ))  and CxaBase.DC_MIA  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_MIA Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaHInv.Num_Proc_HIA Is Not Null and CxaHInv.Num_Lcto Is Null))  and CxaBase.DC_MIA  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_MIA Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaHInv.Num_Proc_HIA Is Not Null and CxaHInv.Num_Lcto Is Null ))  and CxaBase.DC_MIA  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIA Is Null and CtaHInv.Num_Proc_HIA Is Null and CxaBase.DC_MIA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIA Is Null and CtaHInv.Num_Proc_HIA Is Null and CxaBase.DC_MIA  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_MIA as Vlr_Lcto, '', CxaBase.Num_Lcto + ' - ' + CxaBase.Num_Proc_MIA + '  -' +  TT.Nome_Tp_Tx 
	From 
		Caixa_Mas_Imp_Aer as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Mas_Imp_Aer as CtaInv on (CtaInv.Num_Proc_MIA = CxaBase.Num_Proc_MIA and CtaInv.DC_MIA <> CxaBase.DC_MIA and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Imp_Aer as CxaInv on (CxaInv.Num_Proc_MIA = CxaBase.Num_Proc_MIA and CxaInv.DC_MIA <> CxaBase.DC_MIA and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_MIA, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_MIA, 105) and CxaInv.Num_Lcto <> 'PROVISÓRIO') 

		Left Outer Join Cta_Cte_Hou_Imp_Aer as CtaHInv on (Left(CtaHInv.Num_Proc_HIA, 14) = CxaBase.Num_Proc_MIA and CtaHInv.DC_HIA <> CxaBase.DC_MIA and CtaHInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Imp_Aer as CxaHInv on (Left(CxaHInv.Num_Proc_HIA, 14) = CxaBase.Num_Proc_MIA and CxaHInv.DC_HIA <> CxaBase.DC_MIA and CxaHInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaHInv.Dt_Pgto_Rcto_HIA, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_MIA, 105) and CxaHInv.Num_Lcto <> 'PROVISÓRIO') 

		Join Pgto_Rcto as PR on CxaBase.Num_Lcto = PR.Num_Lcto
	Where
		(Convert(Datetime, PR.Dt_Pgto_Rcto, 105) between @Dt_Ini and @Dt_Fim ) and PR.Concil = 'S' and 
		CxaBase.Num_Lcto <> 'PROVISÓRIO'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 

	Insert Into 
		Tmp_Prosoft 
	Select  Distinct 
		@ID_Machine, CxaBase.Num_Lcto, 'PROV', Convert(Datetime, PR.Dt_Pgto_Rcto, 105),  PR.DC, CxaBase.DC_MEM, 
		Cta_Ctb = 
		Case 
			When ((CtaInv.Num_Proc_MEM Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaHInv.Num_Proc_HEM Is Not Null and CxaHInv.Num_Lcto Is Not Null))  and CxaBase.DC_MEM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_MEM Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaHInv.Num_Proc_HEM Is Not Null and CxaHInv.Num_Lcto Is Not Null))  and CxaBase.DC_MEM  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_MEM Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaHInv.Num_Proc_HEM Is Not Null and CxaHInv.Num_Lcto Is Null ))  and CxaBase.DC_MEM  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_MEM Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaHInv.Num_Proc_HEM Is Not Null and CxaHInv.Num_Lcto Is Null))  and CxaBase.DC_MEM  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEM Is Null and CtaHInv.Num_Proc_HEM Is Null and CxaBase.DC_MEM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEM Is Null and CtaHInv.Num_Proc_HEM Is Null and  CxaBase.DC_MEM  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_MEM as Vlr_Lcto, '', CxaBase.Num_Lcto + ' - ' + CxaBase.Num_Proc_MEM + '  -' +  TT.Nome_Tp_Tx 
	From 
		Caixa_Mas_Exp_Mar as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Mas_Exp_Mar as CtaInv on (CtaInv.Num_Proc_MEM = CxaBase.Num_Proc_MEM and CtaInv.DC_MEM <> CxaBase.DC_MEM and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Exp_Mar as CxaInv on (CxaInv.Num_Proc_MEM = CxaBase.Num_Proc_MEM and CxaInv.DC_MEM <> CxaBase.DC_MEM and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_MEM, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_MEM, 105) and CxaInv.Num_Lcto <> 'PROVISÓRIO') 

		Left Outer Join Cta_Cte_Hou_Exp_Mar as CtaHInv on (Left(CtaHInv.Num_Proc_HEM, 14)  = CxaBase.Num_Proc_MEM and CtaHInv.DC_HEM <> CxaBase.DC_MEM and CtaHInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Exp_Mar as CxaHInv on (Left(CxaHInv.Num_Proc_HEM, 14) = CxaBase.Num_Proc_MEM and CxaHInv.DC_HEM <> CxaBase.DC_MEM and CxaHInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaHInv.Dt_Pgto_Rcto_HEM, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_MEM, 105) and CxaHInv.Num_Lcto <> 'PROVISÓRIO') 

		Join Pgto_Rcto as PR on CxaBase.Num_Lcto = PR.Num_Lcto
	Where
		(Convert(Datetime, PR.Dt_Pgto_Rcto, 105) between @Dt_Ini and @Dt_Fim ) and PR.Concil = 'S' and 
		CxaBase.Num_Lcto <> 'PROVISÓRIO'


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 

	Insert Into 
		Tmp_Prosoft 
	Select Distinct 
		@ID_Machine, CxaBase.Num_Lcto, 'PROV', Convert(Datetime, PR.Dt_Pgto_Rcto, 105),  PR.DC, CxaBase.DC_MEA, 
		Cta_Ctb = 
		Case 
			When ((CtaInv.Num_Proc_MEA Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaHInv.Num_Proc_HEA Is Not Null and CxaHInv.Num_Lcto Is Not Null))  and CxaBase.DC_MEA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_MEA Is Not Null and CxaInv.Num_Lcto Is Not Null) or (CtaHInv.Num_Proc_HEA Is Not Null and CxaHInv.Num_Lcto Is Not Null))   and CxaBase.DC_MEA  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_MEA Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaHInv.Num_Proc_HEA Is Not Null and CxaHInv.Num_Lcto Is Null))  and CxaBase.DC_MEA  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When ((CtaInv.Num_Proc_MEA Is Not Null and CxaInv.Num_Lcto Is Null) or (CtaHInv.Num_Proc_HEA Is Not Null and CxaHInv.Num_Lcto Is Null))  and CxaBase.DC_MEA  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEA Is Null and CtaHInv.Num_Proc_HEA Is Null  and CxaBase.DC_MEA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEA Is Null and CtaHInv.Num_Proc_HEA Is Null  and CxaBase.DC_MEA  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		CxaBase.Vlr_Pgto_Rcto_MEA as Vlr_Lcto, '', CxaBase.Num_Lcto + ' - ' + CxaBase.Num_Proc_MEA + '  -' +  TT.Nome_Tp_Tx 
	From 
		Caixa_Mas_Exp_Aer as CxaBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx 
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Mas_Exp_Aer as CtaInv on (CtaInv.Num_Proc_MEA = CxaBase.Num_Proc_MEA and CtaInv.DC_MEA <> CxaBase.DC_MEA and CtaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Exp_Aer as CxaInv on (CxaInv.Num_Proc_MEA = CxaBase.Num_Proc_MEA and CxaInv.DC_MEA <> CxaBase.DC_MEA and CxaInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_MEA, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_MEA, 105) and CxaInv.Num_Lcto <> 'PROVISÓRIO') 

		Left Outer Join Cta_Cte_Hou_Exp_Aer as CtaHInv on (Left(CtaHInv.Num_Proc_HEA, 14) = CxaBase.Num_Proc_MEA and CtaHInv.DC_HEA <> CxaBase.DC_MEA and CtaHInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Exp_Aer as CxaHInv on (Left(CxaHInv.Num_Proc_HEA, 14) = CxaBase.Num_Proc_MEA and CxaHInv.DC_HEA <> CxaBase.DC_MEA and CxaHInv.Cd_Tp_Tx = CxaBase.Cd_Tp_Tx and Convert(Datetime, CxaHInv.Dt_Pgto_Rcto_HEA, 105) <=  Convert(Datetime, CxaBase.Dt_Pgto_Rcto_MEA, 105) and CxaHInv.Num_Lcto <> 'PROVISÓRIO') 

		Join Pgto_Rcto as PR on CxaBase.Num_Lcto = PR.Num_Lcto
	Where
		(Convert(Datetime, PR.Dt_Pgto_Rcto, 105) between @Dt_Ini and @Dt_Fim ) and PR.Concil = 'S' and 
		CxaBase.Num_Lcto <> 'PROVISÓRIO'


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
