SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pProsoftVariacaoM_Sel 
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
	Declare @Cd_Moeda_C		VarChar(3) 
	Declare @Cd_Moeda_D		VarChar(3) 

	Declare @RecAtv		VarChar(5)
	Declare @RecPas		VarChar(5)

	Declare @MarAtv		VarChar(5)
	Declare @MarPas		VarChar(5)

	Declare @AerAtv		VarChar(5)
	Declare @AerPas		VarChar(5)

	Declare @CtaRefAtv		VarChar(5)
	Declare @CtaRefPas		VarChar(5)

	Set @MarAtv = '00572'
	Set @MarPas = '00561' 

	Set @AerAtv = '00573'
	Set @AerPas = '00563'

	Set @RecAtv = '00608'
	Set @RecPas = '00609'


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
	
	--MIM 
	Declare CurHouse Cursor For 
		Select 
			Distinct Cxa1.Num_Proc_MIM, Cxa1.Cd_Tp_Tx
		From 	
			Caixa_Mas_Imp_Mar as Cxa1 Join Caixa_Mas_Imp_Mar as Cxa2 on Cxa2.Num_Proc_MIM = Cxa1.Num_Proc_MIM and Cxa2.Cd_Tp_Tx = Cxa1.Cd_Tp_Tx and Cxa2.DC_MIM <> Cxa1.DC_MIM
		Where
			Cxa1.Num_Lcto <> 'PROVISÓRIO' and Cxa2.Num_Lcto <> 'PROVISÓRIO' and 
			((Convert(Datetime, Cxa1.Dt_Pgto_Rcto_MIM, 105) >= Convert(Datetime, Cxa2.Dt_Pgto_Rcto_MIM, 105)) and Convert(Datetime, Cxa1.Dt_Pgto_Rcto_MIM, 105) between @Dt_ini and @Dt_Fim) or 
			((Convert(Datetime, Cxa2.Dt_Pgto_Rcto_MIM, 105) > Convert(Datetime, Cxa1.Dt_Pgto_Rcto_MIM, 105)) and Convert(Datetime, Cxa2.Dt_Pgto_Rcto_MIM, 105) between @Dt_ini and @Dt_Fim) 
	
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
		
			Select @Tx_Vnd = Par_Moeda_MIM, @Vlr_Vnd = Vlr_Pgto_Rcto_MIM, @DtC = Convert(Datetime, Dt_Pgto_Rcto_MIM, 105)  , @Cd_Moeda_C = Cd_Tp_Moeda
			From Caixa_Mas_Imp_Mar as Cxa Join Cta_Cte_Mas_Imp_Mar as Cte on Cte.Num_Proc_MIM = Cxa.Num_Proc_MIM and Cte.DC_MIM = Cxa.DC_MIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx 
			Where Cxa.Num_Proc_MIM = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_MIM = 'C'
	
			Select @Tx_Cmp = Par_Moeda_MIM, @Vlr_Cmp = Vlr_Pgto_Rcto_MIM, @DtD = Convert(Datetime, Dt_Pgto_Rcto_MIM, 105), @Cd_Moeda_D = Cd_Tp_Moeda   
			From Caixa_Mas_Imp_Mar as Cxa Join Cta_Cte_Mas_Imp_Mar as Cte on Cte.Num_Proc_MIM = Cxa.Num_Proc_MIM and Cte.DC_MIM = Cxa.DC_MIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx 
			Where Cxa.Num_Proc_MIM = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_MIM = 'D'
	
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


			If @Cd_Moeda_C <> @Cd_Moeda_D
				Set @Variacao = 0 				
	
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


	--MIA 
	Declare CurHouse Cursor For 
		Select 
			Distinct Cxa1.Num_Proc_MIA, Cxa1.Cd_Tp_Tx
		From 	
			Caixa_Mas_Imp_Aer as Cxa1 Join Caixa_Mas_Imp_Aer as Cxa2 on Cxa2.Num_Proc_MIA = Cxa1.Num_Proc_MIA and Cxa2.Cd_Tp_Tx = Cxa1.Cd_Tp_Tx and Cxa2.DC_MIA <> Cxa1.DC_MIA
		Where	
			Cxa1.Num_Lcto <> 'PROVISÓRIO' and Cxa2.Num_Lcto <> 'PROVISÓRIO' and 
			((Convert(Datetime, Cxa1.Dt_Pgto_Rcto_MIA, 105) >= Convert(Datetime, Cxa2.Dt_Pgto_Rcto_MIA, 105)) and Convert(Datetime, Cxa1.Dt_Pgto_Rcto_MIA, 105) between @Dt_ini and @Dt_Fim) or 
			((Convert(Datetime, Cxa2.Dt_Pgto_Rcto_MIA, 105) > Convert(Datetime, Cxa1.Dt_Pgto_Rcto_MIA, 105)) and Convert(Datetime, Cxa2.Dt_Pgto_Rcto_MIA, 105) between @Dt_ini and @Dt_Fim) 
	
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
		
			Select @Tx_Vnd = Par_Moeda_MIA, @Vlr_Vnd = Vlr_Pgto_Rcto_MIA, @DtC = Convert(Datetime, Dt_Pgto_Rcto_MIA, 105), @Cd_Moeda_C = Cd_Tp_Moeda  
			From Caixa_Mas_Imp_Aer as Cxa Join Cta_Cte_Mas_Imp_Aer as Cte on Cte.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cte.DC_MIA = Cxa.DC_MIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx 
			Where Cxa.Num_Proc_MIA = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_MIA = 'C'
	
			Select @Tx_Cmp = Par_Moeda_MIA, @Vlr_Cmp = Vlr_Pgto_Rcto_MIA, @DtD = Convert(Datetime, Dt_Pgto_Rcto_MIA, 105) , @Cd_Moeda_D = Cd_Tp_Moeda
			From Caixa_Mas_Imp_Aer   as Cxa Join Cta_Cte_Mas_Imp_Aer as Cte on Cte.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cte.DC_MIA = Cxa.DC_MIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx 
			Where Cxa.Num_Proc_MIA = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_MIA = 'D'
	
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

			If @Cd_Moeda_C <> @Cd_Moeda_D
				Set @Variacao = 0 				

	
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


	--MEM 
	Declare CurHouse Cursor For 
		Select 
			Distinct Cxa1.Num_Proc_MEM, Cxa1.Cd_Tp_Tx
		From 	
			Caixa_Mas_Exp_Mar as Cxa1 Join Caixa_Mas_Exp_Mar as Cxa2 on Cxa2.Num_Proc_MEM = Cxa1.Num_Proc_MEM and Cxa2.Cd_Tp_Tx = Cxa1.Cd_Tp_Tx and Cxa2.DC_MEM <> Cxa1.DC_MEM
		Where
			Cxa1.Num_Lcto <> 'PROVISÓRIO' and Cxa2.Num_Lcto <> 'PROVISÓRIO' and 
			((Convert(Datetime, Cxa1.Dt_Pgto_Rcto_MEM, 105) >= Convert(Datetime, Cxa2.Dt_Pgto_Rcto_MEM, 105)) and Convert(Datetime, Cxa1.Dt_Pgto_Rcto_MEM, 105) between @Dt_ini and @Dt_Fim) or 
			((Convert(Datetime, Cxa2.Dt_Pgto_Rcto_MEM, 105) > Convert(Datetime, Cxa1.Dt_Pgto_Rcto_MEM, 105)) and Convert(Datetime, Cxa2.Dt_Pgto_Rcto_MEM, 105) between @Dt_ini and @Dt_Fim) 
	
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
		
			Select @Tx_Vnd = Par_Moeda_MEM, @Vlr_Vnd = Vlr_Pgto_Rcto_MEM, @DtC = Convert(Datetime, Dt_Pgto_Rcto_MEM, 105), @Cd_Moeda_C = Cd_Tp_Moeda  
			From Caixa_Mas_Exp_Mar as Cxa Join Cta_Cte_Mas_Exp_Mar as Cte on Cte.Num_Proc_MEM = Cxa.Num_Proc_MEM and Cte.DC_MEM = Cxa.DC_MEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx  
			Where Cxa.Num_Proc_MEM = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_MEM = 'C'
	
			Select @Tx_Cmp = Par_Moeda_MEM, @Vlr_Cmp = Vlr_Pgto_Rcto_MEM, @DtD = Convert(Datetime, Dt_Pgto_Rcto_MEM, 105), @Cd_Moeda_D = Cd_Tp_Moeda
			From Caixa_Mas_Exp_Mar as Cxa Join Cta_Cte_Mas_Exp_Mar as Cte on Cte.Num_Proc_MEM = Cxa.Num_Proc_MEM and Cte.DC_MEM = Cxa.DC_MEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx  
			Where Cxa.Num_Proc_MEM = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_MEM = 'D'
	
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

			If @Cd_Moeda_C <> @Cd_Moeda_D
				Set @Variacao = 0 				

	
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

	--MEA 
	Declare CurHouse Cursor For 
		Select 
			Distinct Cxa1.Num_Proc_MEA, Cxa1.Cd_Tp_Tx
		From 	
			Caixa_Mas_Exp_Aer as Cxa1 Join Caixa_Mas_Exp_Aer as Cxa2 on Cxa2.Num_Proc_MEA = Cxa1.Num_Proc_MEA and Cxa2.Cd_Tp_Tx = Cxa1.Cd_Tp_Tx and Cxa2.DC_MEA <> Cxa1.DC_MEA
		Where
			Cxa1.Num_Lcto <> 'PROVISÓRIO' and Cxa2.Num_Lcto <> 'PROVISÓRIO' and 
			((Convert(Datetime, Cxa1.Dt_Pgto_Rcto_MEA, 105) >= Convert(Datetime, Cxa2.Dt_Pgto_Rcto_MEA, 105)) and Convert(Datetime, Cxa1.Dt_Pgto_Rcto_MEA, 105) between @Dt_ini and @Dt_Fim) or 
			((Convert(Datetime, Cxa2.Dt_Pgto_Rcto_MEA, 105) > Convert(Datetime, Cxa1.Dt_Pgto_Rcto_MEA, 105)) and Convert(Datetime, Cxa2.Dt_Pgto_Rcto_MEA, 105) between @Dt_ini and @Dt_Fim) 
	
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
		
			Select @Tx_Vnd = Par_Moeda_MEA, @Vlr_Vnd = Vlr_Pgto_Rcto_MEA, @DtC = Convert(Datetime, Dt_Pgto_Rcto_MEA, 105), @Cd_Moeda_C = Cd_Tp_Moeda  
			From Caixa_Mas_Exp_Aer as Cxa Join Cta_Cte_Mas_Exp_Aer as Cte on Cte.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cte.DC_MEA = Cxa.DC_MEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx  
			Where Cxa.Num_Proc_MEA = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_MEA = 'C'
	
			Select @Tx_Cmp = Par_Moeda_MEA, @Vlr_Cmp = Vlr_Pgto_Rcto_MEA, @DtD = Convert(Datetime, Dt_Pgto_Rcto_MEA, 105) , @Cd_Moeda_D = Cd_Tp_Moeda
			From Caixa_Mas_Exp_Aer as Cxa Join Cta_Cte_Mas_Exp_Aer as Cte on Cte.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cte.DC_MEA = Cxa.DC_MEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx  
			Where Cxa.Num_Proc_MEA = @Processo and Cxa.Cd_Tp_Tx = @Cd_Tp_Tx and Cxa.DC_MEA = 'D'
	
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

			If @Cd_Moeda_C <> @Cd_Moeda_D
				Set @Variacao = 0 				

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
