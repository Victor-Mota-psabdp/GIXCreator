SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pProsoftVariacaoH_Sel 
(
@Periodo		VarChar(7),
@ID_Machine		VarChar(30) 
)
AS
	Declare @Dt_Ini			Datetime 
	Declare @Dt_Fim		Datetime 
	
	Declare @CtaRecAer     		VarChar(5) 
	Declare @CtaRecMar     	VarChar(5) 
	Declare @CtaRecRec     	VarChar(5) 
	Declare @CtaDesOpr     		VarChar(5) 
	Declare @CtaDesAdm     	VarChar(5) 
	Declare @CtaForn       		VarChar(5) 
	Declare @CtaPrjOpr     		VarChar(5) 
	Declare @Processo		VarChar(16) 	
	Declare @Tx_Vnd		Float 
	Declare @Tx_Cmp		Float 
	Declare @Vlr_Vnd		Float 
	Declare @Vlr_Cmp		Float 
	Declare @Cta_P		VarChar(5)
	Declare @Cta_A		VarChar(5)
	Declare @Variacao		Float 
	Declare @DtC			Datetime 
	Declare @DtD			Datetime 

	Declare @DtRef			Datetime 
	Declare @Cta_Ctb_Rec_Ref	VarChar(5) 
	Declare @CC			VarChar(5) 
	Declare @Cd_Tp_Tx		Char(3)
	Declare @Cd_Tp_Moeda_C	VarChar(3)
	Declare @Cd_Tp_Moeda_D	VarChar(3)

	Declare @Par_US_C		Float 
	Declare @Par_US_D		Float 

	Declare @MarAtv		VarChar(5)
	Declare @MarPas		VarChar(5)

	Declare @RecAtv		VarChar(5)
	Declare @RecPas		VarChar(5)

	Declare @AerAtv		VarChar(5)
	Declare @AerPas		VarChar(5)

	Declare @CtaRefAtv		VarChar(5)
	Declare @CtaRefPas		VarChar(5)

	Set @MarAtv = '00572'
	Set @MarPas = '00561' 

	Set @AerAtv = '00573'
	Set @AerPas = '00563'

	Set @RecAtv = '00608'
	Set @RecPas = '00607'
	

	Set @Dt_Ini = Convert(Datetime, '01/' + @Periodo, 105) 
	If Left(@Periodo, 2) = '12'
		Set @Dt_Fim = Convert(Datetime, '31/12/' + Cast((Cast(right(@Periodo, 4) as Int)) as Char(4)), 105) 
	Else
		Set @Dt_Fim = DateAdd(d,  -1, Convert(Datetime, ('01/' + Cast((Cast(Left(@Periodo, 2) as Int) + 1) as VarChar(2))  + Right(@Periodo, 5)), 105))

	

	
	Select 
		@CtaRecAer = CRec_Aer.Cd_Cta_Ctb_Red, @CtaRecMar = CRec_Mar.Cd_Cta_Ctb_Red, 
		@CtaRecRec = CRec_Rec.Cd_Cta_Ctb_Red, @CtaDesOpr = CDsp_Opr.Cd_Cta_Ctb_Red, 
		@CtaDesAdm = CDsp_Adm.Cd_Cta_Ctb_Red, @CtaForn = CDsp_For.Cd_Cta_Ctb_Red, 
		@CtaPrjOpr = CPrj_Opr.Cd_Cta_Ctb_Red
	From 
		Param_Contab as PC Join Cta_Ctb as CRec_Aer on PC.CtaRecAer = CRec_Aer.Cd_Cta_Ctb 
		Join Cta_Ctb as CRec_Mar on PC.CtaRecMar = CRec_Mar.Cd_Cta_Ctb 
		Join Cta_Ctb as CRec_Rec on PC.CtaRecRec = CRec_Rec.Cd_Cta_Ctb 		
		Join Cta_Ctb as CDsp_Opr on PC.CtaDesOpr = CDsp_Opr.Cd_Cta_Ctb 
		Join Cta_Ctb as CDsp_Adm on PC.CtaDesAdm = CDsp_Adm.Cd_Cta_Ctb 
		Join Cta_Ctb as CDsp_For on PC.CtaForn = CDsp_For.Cd_Cta_Ctb 
		Join Cta_Ctb as CPrj_Opr on PC.CtaPrjOpr = CPrj_Opr.Cd_Cta_Ctb 
	
	--HIM 
	Declare CurHouse Cursor For 
		Select 
			Distinct Cxa1.Num_Proc_HIM, Cxa1.Cd_Tp_Tx
		From 	
			Caixa_Hou_Imp_Mar as Cxa1 Join Caixa_Hou_Imp_Mar as Cxa2 on Cxa2.Num_Proc_HIM = Cxa1.Num_Proc_HIM and Cxa2.Cd_Tp_Tx = Cxa1.Cd_Tp_Tx and Cxa2.DC_HIM <> Cxa1.DC_HIM
			Join Cta_Cte_Hou_Imp_Mar as Cte1 on Cte1.Num_Proc_HIM = Cxa1.Num_Proc_HIM and Cte1.Cd_Tp_Tx = Cxa1.Cd_Tp_Tx and Cte1.DC_HIM = Cxa1.DC_HIM
			Join Cta_Cte_Hou_Imp_Mar as Cte2 on Cte2.Num_Proc_HIM = Cxa2.Num_Proc_HIM and Cte2.Cd_Tp_Tx = Cxa2.Cd_Tp_Tx and Cte2.DC_HIM = Cxa2.DC_HIM
		Where
			Cxa1.Num_Lcto <> 'PROVISÓRIO' and Cxa2.Num_Lcto <> 'PROVISÓRIO' and 
			(((Convert(Datetime, Cxa1.Dt_Pgto_Rcto_HIM, 105) >= Convert(Datetime, Cxa2.Dt_Pgto_Rcto_HIM, 105)) and Convert(Datetime, Cxa1.Dt_Pgto_Rcto_HIM, 105) between @Dt_ini and @Dt_Fim) or 
			((Convert(Datetime, Cxa2.Dt_Pgto_Rcto_HIM, 105) > Convert(Datetime, Cxa1.Dt_Pgto_Rcto_HIM, 105)) and Convert(Datetime, Cxa2.Dt_Pgto_Rcto_HIM, 105) between @Dt_ini and @Dt_Fim))  and 
			(Cte1.Cd_Tp_Moeda <> 'REL' and Cte2.Cd_Tp_Moeda <> 'REL' )
	
	Open CurHouse 
	
	Fetch Next From CurHouse into 
	@Processo, @Cd_Tp_Tx
	
	While @@Fetch_Status = 0 
		Begin 

			If Left(@Processo, 5) = 'IMREC'	
				Begin 
					Set @CtaRefAtv = @RecAtv 
					Set @CtaRefPas = @RecPas

				End 
			Else
				Begin 
					Set @CtaRefAtv = @MarAtv 
					Set @CtaRefPas = @MarPas
				End 
	
			Select @Cta_A = CCA.Cd_Cta_Ctb_Red, @Cta_P = CCP.Cd_Cta_Ctb_Red
				From Tipo_Taxa as TT Join Cta_Ctb as CCA on  CCA.Cd_Cta_Ctb = TT.Cd_Cta_Ctb_Atv 
				Join Cta_Ctb as CCP on  CCP.Cd_Cta_Ctb = TT.Cd_Cta_Ctb_Pas  
				Where TT.Cd_Tp_Tx = @Cd_Tp_Tx
		
			Select @Tx_Vnd = Par_Moeda_HIM, @Vlr_Vnd = Vlr_Ref_HIM, @DtC = Convert(Datetime, Dt_Pgto_Rcto_HIM, 105), @Cd_Tp_Moeda_C = Cte.Cd_Tp_Moeda
			From Caixa_Hou_Imp_Mar as Cxa Join Cta_Cte_Hou_Imp_Mar as Cte on Cte.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HIM = Cxa.DC_HIM 
			Where Cxa.Num_Proc_HIM = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_HIM = 'C'
	
			Select @Tx_Cmp = Par_Moeda_HIM, @Vlr_Cmp = Vlr_Ref_HIM, @DtD = Convert(Datetime, Dt_Pgto_Rcto_HIM, 105), @Cd_Tp_Moeda_D = Cte.Cd_Tp_Moeda
			From Caixa_Hou_Imp_Mar as Cxa Join Cta_Cte_Hou_Imp_Mar as Cte on Cte.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HIM = Cxa.DC_HIM 
			Where Cxa.Num_Proc_HIM = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_HIM = 'D'


			If @DtC >= @DtD 
				Begin 
					Set @DtRef = @DtC 
					Set @CC = @Cta_P 
				End 		
			Else 
				Begin 
					Set @DtRef = @DtD 
					Set @CC = @Cta_A 
				End 


	
			If @Vlr_Vnd  > @Vlr_Cmp 
				Set @Variacao = @Vlr_Cmp * (@Tx_Vnd - @Tx_Cmp) 
			Else
				Set @Variacao = @Vlr_Vnd * (@Tx_Vnd - @Tx_Cmp) 


			If @Cd_Tp_Moeda_C <> @Cd_Tp_Moeda_D 
				Begin 
--					Set @Par_US_C =  IsNull((Select Par_Moeda From Paridade Where Cd_Tp_Par = 'IMM' and Cd_Tp_Moeda = @Cd_Tp_Moeda_C and Dt_Par = dbo.strhoje(@DtC)),0)
--					Set @Tx_Vnd = @Par_US_C
--
--					Set @Par_US_D =  IsNull((Select Par_Moeda From Paridade Where Cd_Tp_Par = 'IMM' and Cd_Tp_Moeda = @Cd_Tp_Moeda_D and Dt_Par = dbo.strhoje(@DtD)),0)
--					Set @Tx_Cmp = @Par_US_D
					Set @Variacao = 0 

				End 
	
			If @Variacao > 0 
				Begin 
--					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
--					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'C', 'C',@Cta_Ctb_Rec_Ref, @Variacao, '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'C', 'C',@CtaRefAtv, @Variacao, '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
	
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'C', 'D',@CC, @Variacao, '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
				End 
	
			If @Variacao < 0 
				Begin 
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'D', 'D',@CtaRefPas, abs(@Variacao), '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
	
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'D', 'C',@CC, abs(@Variacao), '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
				End 
			Fetch Next From CurHouse into 
			@Processo, @Cd_Tp_Tx
	
		End 

	Close CurHouse 
	Deallocate CurHouse


	--HIA 
	Declare CurHouse Cursor For 
		Select 
			Distinct Cxa1.Num_Proc_HIA, Cxa1.Cd_Tp_Tx
		From 	
			Caixa_Hou_Imp_Aer as Cxa1 Join Caixa_Hou_Imp_Aer as Cxa2 on Cxa2.Num_Proc_HIA = Cxa1.Num_Proc_HIA and Cxa2.Cd_Tp_Tx = Cxa1.Cd_Tp_Tx and Cxa2.DC_HIA <> Cxa1.DC_HIA
			Join Cta_Cte_Hou_Imp_Aer as Cte1 on Cte1.Num_Proc_HIA = Cxa1.Num_Proc_HIA and Cte1.Cd_Tp_Tx = Cxa1.Cd_Tp_Tx and Cte1.DC_HIA = Cxa1.DC_HIA
			Join Cta_Cte_Hou_Imp_Aer as Cte2 on Cte2.Num_Proc_HIA = Cxa2.Num_Proc_HIA and Cte2.Cd_Tp_Tx = Cxa2.Cd_Tp_Tx and Cte2.DC_HIA = Cxa2.DC_HIA
		Where
			Cxa1.Num_Lcto <> 'PROVISÓRIO' and Cxa2.Num_Lcto <> 'PROVISÓRIO' and 
			(((Convert(Datetime, Cxa1.Dt_Pgto_Rcto_HIA, 105) >= Convert(Datetime, Cxa2.Dt_Pgto_Rcto_HIA, 105)) and Convert(Datetime, Cxa1.Dt_Pgto_Rcto_HIA, 105) between @Dt_ini and @Dt_Fim) or 
			((Convert(Datetime, Cxa2.Dt_Pgto_Rcto_HIA, 105) > Convert(Datetime, Cxa1.Dt_Pgto_Rcto_HIA, 105)) and Convert(Datetime, Cxa2.Dt_Pgto_Rcto_HIA, 105) between @Dt_ini and @Dt_Fim))  and 
			(Cte1.Cd_Tp_Moeda <> 'REL' and Cte2.Cd_Tp_Moeda  <> 'REL')
	
	Open CurHouse 
	
	Fetch Next From CurHouse into 
	@Processo, @Cd_Tp_Tx
	
	While @@Fetch_Status = 0 
		Begin 
	
			If Left(@Processo, 5) = 'IAREC'	
				Begin 
					Set @CtaRefAtv = @RecAtv 
					Set @CtaRefPas = @RecPas

				End 
			Else
				Begin 
					Set @CtaRefAtv = @AerAtv 
					Set @CtaRefPas = @AerPas
				End 
	
	
			Select @Cta_A = CCA.Cd_Cta_Ctb_Red, @Cta_P = CCP.Cd_Cta_Ctb_Red
				From Tipo_Taxa as TT Join Cta_Ctb as CCA on  CCA.Cd_Cta_Ctb = TT.Cd_Cta_Ctb_Atv 
				Join Cta_Ctb as CCP on  CCP.Cd_Cta_Ctb = TT.Cd_Cta_Ctb_Pas  
				Where TT.Cd_Tp_Tx = @Cd_Tp_Tx
		
			Select @Tx_Vnd = Par_Moeda_HIA, @Vlr_Vnd = Vlr_Ref_HIa, @DtC = Convert(Datetime, Dt_Pgto_Rcto_HIA, 105), @Cd_Tp_Moeda_C = Cte.Cd_Tp_Moeda 
			From Caixa_Hou_Imp_Aer  as Cxa Join Cta_Cte_Hou_Imp_Aer as Cte on Cte.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HIA = Cxa.DC_HIA
			Where Cxa.Num_Proc_HIA = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_HIA = 'C'
	
			Select @Tx_Cmp = Par_Moeda_HIA, @Vlr_Cmp = Vlr_Ref_HIA, @DtD = Convert(Datetime, Dt_Pgto_Rcto_HIA, 105), @Cd_Tp_Moeda_D = Cte.Cd_Tp_Moeda 
			From Caixa_Hou_Imp_Aer as Cxa Join Cta_Cte_Hou_Imp_Aer as Cte on Cte.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HIA = Cxa.DC_HIA
			Where Cxa.Num_Proc_HIA = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_HIA = 'D'
	

			If @DtC >= @DtD 
				Begin 
					Set @DtRef = @DtC 
					Set @CC = @Cta_P
				End 		
			Else 
				Begin 
					Set @DtRef = @DtD 
					Set @CC = @Cta_A
				End 
	
			If @Vlr_Vnd  > @Vlr_Cmp 
				Set @Variacao = @Vlr_Cmp * (@Tx_Vnd - @Tx_Cmp)
			Else
				Set @Variacao = @Vlr_Vnd * (@Tx_Vnd - @Tx_Cmp)

			If @Cd_Tp_Moeda_C <> @Cd_Tp_Moeda_D 
				Begin 
--					Set @Par_US_C =  IsNull((Select Par_Moeda From Paridade Where Cd_Tp_Par = 'IMA' and Cd_Tp_Moeda = @Cd_Tp_Moeda_C and Dt_Par = dbo.strhoje(@DtC)),0)
--					Set @Tx_Vnd = @Par_US_C
--
--					Set @Par_US_D =  IsNull((Select Par_Moeda From Paridade Where Cd_Tp_Par = 'IMA' and Cd_Tp_Moeda = @Cd_Tp_Moeda_D and Dt_Par = dbo.strhoje(@DtD)),0)
--					Set @Tx_Cmp = @Par_US_D
					Set @Variacao = 0 
				End 

			If @Variacao > 0 
				Begin 
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'C', 'C', @CtaRefAtv, @Variacao, '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
	
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'C', 'D',@CC, @Variacao, '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
				End 
	
			If @Variacao < 0 
				Begin 
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'D', 'D', @CtaRefPas, abs(@Variacao), '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
	
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'D', 'C',@CC, abs(@Variacao), '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
				End 
			Fetch Next From CurHouse into 
			@Processo, @Cd_Tp_Tx
	
		End 

	Close CurHouse 
	Deallocate CurHouse


	--HEM 
	Declare CurHouse Cursor For 
		Select 
			Distinct Cxa1.Num_Proc_HEM, Cxa1.Cd_Tp_Tx
		From 	
			Caixa_Hou_Exp_Mar as Cxa1 Join Caixa_Hou_Exp_Mar as Cxa2 on Cxa2.Num_Proc_HEM = Cxa1.Num_Proc_HEM and Cxa2.Cd_Tp_Tx = Cxa1.Cd_Tp_Tx and Cxa2.DC_HEM <> Cxa1.DC_HEM
			Join Cta_Cte_Hou_Exp_Mar as Cte1 on Cte1.Num_Proc_HEM = Cxa1.Num_Proc_HEM and Cte1.Cd_Tp_Tx = Cxa1.Cd_Tp_Tx and Cte1.DC_HEM = Cxa1.DC_HEM
			Join Cta_Cte_Hou_Exp_Mar as Cte2 on Cte2.Num_Proc_HEM = Cxa2.Num_Proc_HEM and Cte2.Cd_Tp_Tx = Cxa2.Cd_Tp_Tx and Cte2.DC_HEM = Cxa2.DC_HEM
		Where
			Cxa1.Num_Lcto <> 'PROVISÓRIO' and Cxa2.Num_Lcto <> 'PROVISÓRIO' and 
			(((Convert(Datetime, Cxa1.Dt_Pgto_Rcto_HEM, 105) >= Convert(Datetime, Cxa2.Dt_Pgto_Rcto_HEM, 105)) and Convert(Datetime, Cxa1.Dt_Pgto_Rcto_HEM, 105) between @Dt_ini and @Dt_Fim) or 
			((Convert(Datetime, Cxa2.Dt_Pgto_Rcto_HEM, 105) > Convert(Datetime, Cxa1.Dt_Pgto_Rcto_HEM, 105)) and Convert(Datetime, Cxa2.Dt_Pgto_Rcto_HEM, 105) between @Dt_ini and @Dt_Fim))  and 
			(Cte1.Cd_Tp_Moeda <> 'REL' and Cte2.Cd_Tp_Moeda <> 'REL' )

	
	Open CurHouse 
	
	Fetch Next From CurHouse into 
	@Processo, @Cd_Tp_Tx
	
	While @@Fetch_Status = 0 
		Begin 
	
			If Left(@Processo, 5) = 'EMREC'	
				Begin 
					Set @CtaRefAtv = @RecAtv 
					Set @CtaRefPas = @RecPas

				End 
			Else
				Begin 
					Set @CtaRefAtv = @MarAtv 
					Set @CtaRefPas = @MarPas
				End 
	
	
			Select @Cta_A = CCA.Cd_Cta_Ctb_Red, @Cta_P = CCP.Cd_Cta_Ctb_Red
				From Tipo_Taxa as TT Join Cta_Ctb as CCA on  CCA.Cd_Cta_Ctb = TT.Cd_Cta_Ctb_Atv 
				Join Cta_Ctb as CCP on  CCP.Cd_Cta_Ctb = TT.Cd_Cta_Ctb_Pas  
				Where TT.Cd_Tp_Tx = @Cd_Tp_Tx
		
			Select @Tx_Vnd = Par_Moeda_HEM, @Vlr_Vnd = Vlr_Ref_HEM, @DtC = Convert(Datetime, Dt_Pgto_Rcto_HEM, 105), @Cd_Tp_Moeda_C = Cte.Cd_Tp_Moeda
			From Caixa_Hou_Exp_Mar  as Cxa Join Cta_Cte_Hou_Exp_Mar as Cte on Cte.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HEM = Cxa.DC_HEM
			Where Cxa.Num_Proc_HEM = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_HEM = 'C'
	
			Select @Tx_Cmp = Par_Moeda_HEM, @Vlr_Cmp = Vlr_Ref_HEM, @DtD = Convert(Datetime, Dt_Pgto_Rcto_HEM, 105)   , @Cd_Tp_Moeda_D = Cte.Cd_Tp_Moeda
			From Caixa_Hou_Exp_Mar as Cxa Join Cta_Cte_Hou_Exp_Mar as Cte on Cte.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HEM = Cxa.DC_HEM
			Where Cxa.Num_Proc_HEM = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_HEM = 'D'
	



			If @DtC >= @DtD 
				Begin 
					Set @DtRef = @DtC 
					Set @CC = @Cta_P
				End 		
			Else 
				Begin 
					Set @DtRef = @DtD 
					Set @CC = @Cta_A
				End 

			If @Cd_Tp_Moeda_C <> @Cd_Tp_Moeda_D 
				Begin 
--					Set @Par_US_C =  IsNull((Select Par_Moeda From Paridade Where Cd_Tp_Par = 'EXM' and Cd_Tp_Moeda = @Cd_Tp_Moeda_C and Dt_Par = dbo.strhoje(@DtC)),0)
--					Set @Tx_Vnd = @Par_US_C
--					Set @Par_US_D =  IsNull((Select Par_Moeda From Paridade Where Cd_Tp_Par = 'EXM' and Cd_Tp_Moeda = @Cd_Tp_Moeda_D and Dt_Par = dbo.strhoje(@DtD)),0)--
--					Set @Tx_Cmp = @Par_US_D
					Set @Variacao = 0 
				End 
	
			If @Vlr_Vnd  > @Vlr_Cmp 
				Set @Variacao = @Vlr_Cmp * (@Tx_Vnd - @Tx_Cmp)
			Else
				Set @Variacao = @Vlr_Vnd * (@Tx_Vnd - @Tx_Cmp)
	
			If @Variacao > 0 
				Begin 
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'C', 'C',@CtaRefAtv, @Variacao, '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
	
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'C', 'D',@CC, @Variacao, '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
				End 
	
			If @Variacao < 0 
				Begin 
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'D', 'D',@CtaRefPas, abs(@Variacao), '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
	
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'D', 'C',@CC, abs(@Variacao), '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
				End 
			Fetch Next From CurHouse into 
			@Processo, @Cd_Tp_Tx
	
		End 

	Close CurHouse 
	Deallocate CurHouse

	--HEA 
	Declare CurHouse Cursor For 
		Select 
			Distinct Cxa1.Num_Proc_HEA, Cxa1.Cd_Tp_Tx
		From 	
			Caixa_Hou_Exp_Aer as Cxa1 Join Caixa_Hou_Exp_Aer as Cxa2 on Cxa2.Num_Proc_HEA = Cxa1.Num_Proc_HEA and Cxa2.Cd_Tp_Tx = Cxa1.Cd_Tp_Tx and Cxa2.DC_HEA <> Cxa1.DC_HEA
			Join Cta_Cte_Hou_Exp_Aer as Cte1 on Cte1.Num_Proc_HEA = Cxa1.Num_Proc_HEA and Cte1.Cd_Tp_Tx = Cxa1.Cd_Tp_Tx and Cte1.DC_HEA = Cxa1.DC_HEA
			Join Cta_Cte_Hou_Exp_Aer as Cte2 on Cte2.Num_Proc_HEA = Cxa2.Num_Proc_HEA and Cte2.Cd_Tp_Tx = Cxa2.Cd_Tp_Tx and Cte2.DC_HEA = Cxa2.DC_HEA

		Where
			Cxa1.Num_Lcto <> 'PROVISÓRIO' and Cxa2.Num_Lcto <> 'PROVISÓRIO' and 
			(((Convert(Datetime, Cxa1.Dt_Pgto_Rcto_HEA, 105) >= Convert(Datetime, Cxa2.Dt_Pgto_Rcto_HEA, 105)) and Convert(Datetime, Cxa1.Dt_Pgto_Rcto_HEA, 105) between @Dt_ini and @Dt_Fim) or 
			((Convert(Datetime, Cxa2.Dt_Pgto_Rcto_HEA, 105) > Convert(Datetime, Cxa1.Dt_Pgto_Rcto_HEA, 105)) and Convert(Datetime, Cxa2.Dt_Pgto_Rcto_HEA, 105) between @Dt_ini and @Dt_Fim)) 
			and (Cte1.Cd_Tp_Moeda <> 'REL' and Cte2.Cd_Tp_Moeda <> 'REL' )
	Open CurHouse 
	
	Fetch Next From CurHouse into 
	@Processo, @Cd_Tp_Tx
	
	While @@Fetch_Status = 0 
		Begin 
	
			If Left(@Processo, 5) = 'EAREC'	
				Begin 
					Set @CtaRefAtv = @RecAtv 
					Set @CtaRefPas = @RecPas

				End 
			Else
				Begin 
					Set @CtaRefAtv = @AerAtv 
					Set @CtaRefPas = @AerPas
				End 
	
	
			Select @Cta_A = CCA.Cd_Cta_Ctb_Red, @Cta_P = CCP.Cd_Cta_Ctb_Red
				From Tipo_Taxa as TT Join Cta_Ctb as CCA on  CCA.Cd_Cta_Ctb = TT.Cd_Cta_Ctb_Atv 
				Join Cta_Ctb as CCP on  CCP.Cd_Cta_Ctb = TT.Cd_Cta_Ctb_Pas  
				Where TT.Cd_Tp_Tx = @Cd_Tp_Tx
		
			Select @Tx_Vnd = Par_Moeda_HEA, @Vlr_Vnd = Vlr_Ref_HEA, @DtC = Convert(Datetime, Dt_Pgto_Rcto_HEA, 105), @Cd_Tp_Moeda_C = Cte.Cd_Tp_Moeda
			From Caixa_Hou_Exp_Aer  as Cxa Join Cta_Cte_Hou_Exp_Aer as Cte on Cte.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HEA = Cxa.DC_HEA
			Where Cxa.Num_Proc_HEA = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_HEA = 'C'
	
			Select @Tx_Cmp = Par_Moeda_HEA, @Vlr_Cmp = Vlr_Ref_HEA, @DtD = Convert(Datetime, Dt_Pgto_Rcto_HEA, 105) , @Cd_Tp_Moeda_C = Cte.Cd_Tp_Moeda
			From Caixa_Hou_Exp_Aer as Cxa Join Cta_Cte_Hou_Exp_Aer as Cte on Cte.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HEA = Cxa.DC_HEA
			Where Cxa.Num_Proc_HEA = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_HEA = 'D'
	

			If @DtC >= @DtD 
				Begin 
					Set @DtRef = @DtC 
					Set @CC = @Cta_P
				End 		
			Else 
				Begin 
					Set @DtRef = @DtD 
					Set @CC = @Cta_A
				End 
	
			If @Vlr_Vnd  > @Vlr_Cmp 
				Set @Variacao = @Vlr_Cmp * (@Tx_Vnd - @Tx_Cmp)
			Else
				Set @Variacao = @Vlr_Vnd * (@Tx_Vnd - @Tx_Cmp)


			If @Cd_Tp_Moeda_C <> @Cd_Tp_Moeda_D 
				Begin 
--					Set @Par_US_C =  IsNull((Select Par_Moeda From Paridade Where Cd_Tp_Par = 'EXA' and Cd_Tp_Moeda = @Cd_Tp_Moeda_C and Dt_Par = dbo.strhoje(@DtC)),0)
--					Set @Tx_Vnd = @Par_US_C

--					Set @Par_US_D =  IsNull((Select Par_Moeda From Paridade Where Cd_Tp_Par = 'EXA' and Cd_Tp_Moeda = @Cd_Tp_Moeda_D and Dt_Par = dbo.strhoje(@DtD)),0)
--					Set @Tx_Cmp = @Par_US_D
					Set @Variacao = 0 
				End 
	
			If @Variacao > 0 
				Begin 
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'C', 'C',@CtaRefAtv, @Variacao, '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
	
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'C', 'D',@CC, @Variacao, '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
				End 
	
			If @Variacao < 0 
				Begin 
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'D', 'D',@CtaRefPas, abs(@Variacao), '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
	
					Insert Into Tmp_Prosoft (IDMachine, Num_Doc, Num_Doc_Compl, Dt_Doc, DC_Doc, DC_Tax, Cta_Ctb, Vlr_Lcto, CCusto, Historico)
					Values (@ID_Machine, @Processo + @Cd_Tp_Tx, '', @DtRef, 'D', 'C',@CC, abs(@Variacao), '', 'Variação Cambial - ' + @Processo + '(' + @Cd_Tp_Tx + ')' ) 				
	
					If @@Error <> 0 
						Begin 
							Deallocate CurHouse 
							--RollBack Transaction 
							Return -1 
						End 
				End 
			Fetch Next From CurHouse into 
			@Processo, @Cd_Tp_Tx
	
		End 

	Close CurHouse 
	Deallocate CurHouse

	--Commit Transaction 
	Return 1
GO
