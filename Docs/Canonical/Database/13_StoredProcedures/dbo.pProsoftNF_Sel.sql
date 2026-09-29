SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pProsoftNF_Sel 
(
@Periodo		VarChar(7),
@ID_Machine		VarChar(30) 
)
AS
	Declare @Dt_Ini		Datetime 
	Declare @Dt_Fim	Datetime 
	Declare @StrDt		VarChar(10) 
	Declare @CtaRecAer     	VarChar(5)
	Declare @CtaRecMar     VarChar(5)
	Declare @CtaRecRec	VarChar(5)

	Select  
		@CtaRecAer = Rec_Aer.Cd_Cta_Ctb_Red, 
		@CtaRecMar = Rec_Mar.Cd_Cta_Ctb_Red, 
		@CtaRecRec = Rec_Rec.Cd_Cta_Ctb_Red 
	From 
		Param_Contab as PC Join Cta_Ctb as Rec_Aer on Rec_Aer.Cd_Cta_Ctb = PC.CtaRecAer
		Join Cta_Ctb as Rec_Mar on Rec_Mar.Cd_Cta_Ctb = PC.CtaRecMar
		Join Cta_Ctb as Rec_Rec on Rec_Rec.Cd_Cta_Ctb  = PC.CtaRecRec


	Set @Dt_Ini = Convert(Datetime, '01/' + @Periodo, 105) 
	If Left(@Periodo, 2) = '12'
		Set @Dt_Fim = Convert(Datetime, '31/12/' + Cast((Cast(right(@Periodo, 4) as Int) ) as Char(4)), 105) 
	Else
		Set @Dt_Fim = DateAdd(d,  -1, Convert(Datetime, ('01/' + Cast((Cast(Left(@Periodo, 2) as Int) + 1) as VarChar(2))  + Right(@Periodo, 5)), 105))

	Insert Into 
		Tmp_Prosoft 

	Select 
		@ID_Machine, 'NF' + Ref_Acesso +  Nota_Fiscal , '', Convert(Datetime, Emissao, 105),  'C', 'C', 
		Cta_Ctb = 
		Case 
			When Ref_Acesso = 'A' then @CtaRecAer
			When Ref_Acesso = 'B' then @CtaRecMar
			When Ref_Acesso = 'C' then  @CtaRecRec
		End, 
		Valor_Total, '', 'Emissao de NF nr. ' + Nota_Fiscal + ' - ' + Cli.Nome_Raz_Soc 
	From 
		Base_Nota_Fiscal as BN 
		Join Pessoa as Cli on Cli.Cd_Pes = BN.Cd_Pes 
	Where
		(BN.Emissao between @Dt_Ini and @Dt_Fim )  and 
		Cd_Status = 1 


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -20
		End 


	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, 'NF' + Ref_Acesso +  BN.Nota_Fiscal, '', BN.Emissao,  'D', 
		DC = 
		Case 
			When CteBase.DC_HIA = 'C' then 'D'
			Else 'C'
		End, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_HIA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_HIA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_HIA  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIA Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_HIA  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIA Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_HIA  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIA Is Null and CteBase.DC_HIA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIA Is Null and CteBase.DC_HIA  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		Vlr_Lcto = 
		Case 
			When CteBase.Vlr_Pgto_NF_HIA  Is Null then 0 
			Else  CteBase.Vlr_Pgto_NF_HIA 
		End, 
		 '',   BN.Nota_Fiscal + ' - ' + TT.Nome_Tp_Tx 
	From 
		Cta_Cte_Hou_Imp_Aer as CteBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CteBase.Cd_Tp_Tx 
		Join Base_Nota_Fiscal as BN on (BN.Nota_Fiscal = CteBase.Num_NF_HIA and BN.Ref_Acesso = CteBase.Ref_Acesso_NF_HIA)
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Hou_Imp_Aer as CtaInv on (CtaInv.Num_Proc_HIA = CteBase.Num_Proc_HIA and CtaInv.DC_HIA <> CteBase.DC_HIA and CtaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Imp_Aer as CxaInv on (CxaInv.Num_Proc_HIA = CteBase.Num_Proc_HIA and CxaInv.DC_HIA <> CteBase.DC_HIA and CxaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_HIA, 105) <=  BN.Emissao) 

	Where
		(BN.Emissao between @Dt_Ini and @Dt_Fim ) 


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 



	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, 'NF' + Ref_Acesso +  BN.Nota_Fiscal, '', BN.Emissao,  'D', 
		DC = 
		Case 
			When CteBase.DC_HIM = 'C' then 'D'
			Else 'C'
		End, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_HIM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_HIM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_HIM  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIM Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_HIM  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIM Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_HIM  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIM Is Null and CteBase.DC_HIM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HIM Is Null and CteBase.DC_HIM  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		Vlr_Lcto = 
		Case 
			When CteBase.Vlr_Pgto_NF_HIM  Is Null then 0 
			Else  CteBase.Vlr_Pgto_NF_HIM 
		End, 
		 '',   BN.Nota_Fiscal + ' - ' + TT.Nome_Tp_Tx 
	From 
		Cta_Cte_Hou_Imp_Mar as CteBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CteBase.Cd_Tp_Tx 
		Join Base_Nota_Fiscal as BN on (BN.Nota_Fiscal = CteBase.Num_NF_HIM and BN.Ref_Acesso = CteBase.Ref_Acesso_NF_HIM)
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Hou_Imp_Mar as CtaInv on (CtaInv.Num_Proc_HIM = CteBase.Num_Proc_HIM and CtaInv.DC_HIM <> CteBase.DC_HIM and CtaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Imp_Mar as CxaInv on (CxaInv.Num_Proc_HIM = CteBase.Num_Proc_HIM and CxaInv.DC_HIM <> CteBase.DC_HIM and CxaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_HIM, 105) <=  BN.Emissao) 

	Where
		(BN.Emissao between @Dt_Ini and @Dt_Fim ) 


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 


	Insert Into 
		Tmp_Prosoft 
	Select 

		 @ID_Machine,'NF' + Ref_Acesso +   BN.Nota_Fiscal, '', BN.Emissao,  'D', 
		DC = 
		Case 
			When CteBase.DC_HEA = 'C' then 'D'
			Else 'C'
		End, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_HEA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_HEA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_HEA  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEA Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_HEA  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEA Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_HEA  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEA Is Null and CteBase.DC_HEA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEA Is Null and CteBase.DC_HEA  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		Vlr_Lcto = 
		Case 
			When CteBase.Vlr_Pgto_NF_HEA  Is Null then 0 
			Else  CteBase.Vlr_Pgto_NF_HEA 
		End, 
		'',   BN.Nota_Fiscal + ' - ' + TT.Nome_Tp_Tx 
	From 
		Cta_Cte_Hou_Exp_Aer as CteBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CteBase.Cd_Tp_Tx 
		Join Base_Nota_Fiscal as BN on (BN.Nota_Fiscal = CteBase.Num_NF_HEA and BN.Ref_Acesso = CteBase.Ref_Acesso_NF_HEA)
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Hou_Exp_Aer as CtaInv on (CtaInv.Num_Proc_HEA = CteBase.Num_Proc_HEA and CtaInv.DC_HEA <> CteBase.DC_HEA and CtaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Exp_Aer as CxaInv on (CxaInv.Num_Proc_HEA = CteBase.Num_Proc_HEA and CxaInv.DC_HEA <> CteBase.DC_HEA and CxaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_HEA, 105) <=  BN.Emissao) 
	Where
		(BN.Emissao between @Dt_Ini and @Dt_Fim ) 


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 


	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, 'NF' + Ref_Acesso +  BN.Nota_Fiscal, '', BN.Emissao,  'D', 
		DC = 
		Case 
			When CteBase.DC_HEM = 'C' then 'D'
			Else 'C'
		End, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_HEM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_HEM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_HEM  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEM Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_HEM  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEM Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_HEM  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEM Is Null and CteBase.DC_HEM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_HEM Is Null and CteBase.DC_HEM  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		Vlr_Lcto = 
		Case 
			When CteBase.Vlr_Pgto_NF_HEM  Is Null then 0 
			Else  CteBase.Vlr_Pgto_NF_HEM 
		End,  
		'',   BN.Nota_Fiscal + ' - ' + TT.Nome_Tp_Tx 
	From 
		Cta_Cte_Hou_Exp_Mar as CteBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CteBase.Cd_Tp_Tx 
		Join Base_Nota_Fiscal as BN on (BN.Nota_Fiscal = CteBase.Num_NF_HEM and BN.Ref_Acesso = CteBase.Ref_Acesso_NF_HEM)
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Hou_Exp_Mar as CtaInv on (CtaInv.Num_Proc_HEM = CteBase.Num_Proc_HEM and CtaInv.DC_HEM <> CteBase.DC_HEM and CtaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Hou_Exp_Mar as CxaInv on (CxaInv.Num_Proc_HEM = CteBase.Num_Proc_HEM and CxaInv.DC_HEM <> CteBase.DC_HEM and CxaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_HEM, 105) <=  BN.Emissao) 

	Where
		(BN.Emissao between @Dt_Ini and @Dt_Fim ) 


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 


	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, 'NF' + Ref_Acesso +  BN.Nota_Fiscal, '', BN.Emissao,  'D', 
		DC = 
		Case 
			When CteBase.DC_MIA = 'C' then 'D'
			Else 'C'
		End, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_MIA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_MIA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_MIA  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIA Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_MIA  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIA Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_MIA  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIA Is Null and CteBase.DC_MIA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIA Is Null and CteBase.DC_MIA  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		Vlr_Lcto = 
		Case 
			When CteBase.Vlr_Pgto_NF_MIA  Is Null then 0 
			Else  CteBase.Vlr_Pgto_NF_MIA
		End, 
		'',   BN.Nota_Fiscal + ' - ' + TT.Nome_Tp_Tx 
	From 
		Cta_Cte_Mas_Imp_Aer as CteBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CteBase.Cd_Tp_Tx 
		Join Base_Nota_Fiscal as BN on (BN.Nota_Fiscal = CteBase.Num_NF_MIA and BN.Ref_Acesso = CteBase.Ref_Acesso_NF_MIA)
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Mas_Imp_Aer as CtaInv on (CtaInv.Num_Proc_MIA = CteBase.Num_Proc_MIA and CtaInv.DC_MIA <> CteBase.DC_MIA and CtaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Imp_Aer as CxaInv on (CxaInv.Num_Proc_MIA = CteBase.Num_Proc_MIA and CxaInv.DC_MIA <> CteBase.DC_MIA and CxaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_MIA, 105) <= BN.Emissao) 

	Where
		(BN.Emissao between @Dt_Ini and @Dt_Fim ) 


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 



	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, 'NF' + Ref_Acesso +  BN.Nota_Fiscal, '', BN.Emissao,  'D', 
		DC = 
		Case 
			When CteBase.DC_MIM = 'C' then 'D'
			Else 'C'
		End, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_MIM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_MIM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_MIM  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIM Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_MIM  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIM Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_MIM  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIM Is Null and CteBase.DC_MIM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MIM Is Null and CteBase.DC_MIM  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		Vlr_Lcto = 
		Case 
			When CteBase.Vlr_Pgto_NF_MIM  Is Null then 0 
			Else  CteBase.Vlr_Pgto_NF_MIM 
		End, 
		'',   BN.Nota_Fiscal + ' - ' + TT.Nome_Tp_Tx 
	From 
		Cta_Cte_Mas_Imp_Mar as CteBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CteBase.Cd_Tp_Tx 
		Join Base_Nota_Fiscal as BN on (BN.Nota_Fiscal = CteBase.Num_NF_MIM and BN.Ref_Acesso = CteBase.Ref_Acesso_NF_MIM)
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Mas_Imp_Mar as CtaInv on (CtaInv.Num_Proc_MIM = CteBase.Num_Proc_MIM and CtaInv.DC_MIM <> CteBase.DC_MIM and CtaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Imp_Mar as CxaInv on (CxaInv.Num_Proc_MIM = CteBase.Num_Proc_MIM and CxaInv.DC_MIM <> CteBase.DC_MIM and CxaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_MIM, 105) <=  BN.Emissao) 

	Where
		(BN.Emissao between @Dt_Ini and @Dt_Fim ) 


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 


	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, 'NF' + Ref_Acesso +  BN.Nota_Fiscal, '', BN.Emissao,  'D', 
		DC = 
		Case 
			When CteBase.DC_MEA = 'C' then 'D'
			Else 'C'
		End, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_MEA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_MEA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEA Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_MEA  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEA Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_MEA  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEA Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_MEA  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEA Is Null and CteBase.DC_MEA  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEA Is Null and CteBase.DC_MEA  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		Vlr_Lcto = 
		Case 
			When CteBase.Vlr_Pgto_NF_MEA  Is Null then 0 
			Else  CteBase.Vlr_Pgto_NF_MEA 
		End, 
		 '',   BN.Nota_Fiscal + ' - ' + TT.Nome_Tp_Tx 
	From 
		Cta_Cte_Mas_Exp_Aer as CteBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CteBase.Cd_Tp_Tx 
		Join Base_Nota_Fiscal as BN on (BN.Nota_Fiscal = CteBase.Num_NF_MEA and BN.Ref_Acesso = CteBase.Ref_Acesso_NF_MEA)
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Mas_Exp_Aer as CtaInv on (CtaInv.Num_Proc_MEA = CteBase.Num_Proc_MEA and CtaInv.DC_MEA <> CteBase.DC_MEA and CtaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Exp_Aer as CxaInv on (CxaInv.Num_Proc_MEA = CteBase.Num_Proc_MEA and CxaInv.DC_MEA <> CteBase.DC_MEA and CxaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_MEA, 105) <= BN.Emissao) 

	Where
		(BN.Emissao between @Dt_Ini and @Dt_Fim ) 


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End 


	Insert Into 
		Tmp_Prosoft 
	Select 
		 @ID_Machine, 'NF' + Ref_Acesso +  BN.Nota_Fiscal, '', BN.Emissao,  'D', 
		DC = 
		Case 
			When CteBase.DC_MEM = 'C' then 'D'
			Else 'C'
		End, 
		Cta_Ctb = 
		Case 
			When CtaInv.Num_Proc_MEM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_MEM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEM Is Not Null and CxaInv.Num_Lcto Is Not Null  and CteBase.DC_MEM  = 'D' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEM Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_MEM  = 'C' then CCPas.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEM Is Not Null and CxaInv.Num_Lcto Is Null  and CteBase.DC_MEM  = 'D' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEM Is Null and CteBase.DC_MEM  = 'C' then CCAtv.Cd_Cta_Ctb_Red 
			When CtaInv.Num_Proc_MEM Is Null and CteBase.DC_MEM  = 'D' then CCPas.Cd_Cta_Ctb_Red 

		End, 
		Vlr_Lcto = 
		Case 
			When CteBase.Vlr_Pgto_NF_MEM  Is Null then 0 
			Else  CteBase.Vlr_Pgto_NF_MEM 
		End, 
		 '',   BN.Nota_Fiscal + ' - ' + TT.Nome_Tp_Tx 
	From 
		Cta_Cte_Mas_Exp_Mar as CteBase Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = CteBase.Cd_Tp_Tx 
		Join Base_Nota_Fiscal as BN on (BN.Nota_Fiscal = CteBase.Num_NF_MEM and BN.Ref_Acesso = CteBase.Ref_Acesso_NF_MEM)
		Left Outer Join Cta_Ctb as CCAtv on TT.Cd_Cta_Ctb_Atv = CCAtv.Cd_Cta_Ctb 
		Left Outer Join Cta_Ctb as CCPas on TT.Cd_Cta_Ctb_Pas = CCPas.Cd_Cta_Ctb 
		Left Outer Join Cta_Cte_Mas_Exp_Mar as CtaInv on (CtaInv.Num_Proc_MEM = CteBase.Num_Proc_MEM and CtaInv.DC_MEM <> CteBase.DC_MEM and CtaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx) 
		Left Outer Join Caixa_Mas_Exp_Mar as CxaInv on (CxaInv.Num_Proc_MEM = CteBase.Num_Proc_MEM and CxaInv.DC_MEM <> CteBase.DC_MEM and CxaInv.Cd_Tp_Tx = CteBase.Cd_Tp_Tx and Convert(Datetime, CxaInv.Dt_Pgto_Rcto_MEM, 105) <=  BN.Emissao) 
	Where
		(BN.Emissao between @Dt_Ini and @Dt_Fim ) 


	If @@Error  <> 0 
		Begin 
			--RollBack Transaction 
			Return -21
		End

	Return 1

GO
