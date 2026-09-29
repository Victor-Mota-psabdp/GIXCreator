SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pReciboMasterTotal_Sel    Script Date: 06/11/2002 13:42:19 ******/
CREATE PROCEDURE pReciboMasterTotal_Sel
(
@Site			Char(1),
@Num_Proc 		VarChar(16),
@Recibo 		VarChar(12), 
@TotalBruto		Float  	OUTPUT,
@IRRF			Float	OUTPUT,
@TotalLiq		Float 	OUTPUT
)
 AS	
	Declare @Limite_Ded_IRRF 	Float
	Declare @Perc_IRRF		Float
	Declare @TaxaDC		Char(1)
	Declare @TaxaValor		Float 
	Declare @BaseIRRF		Float
	Declare @TaxaIRRF		Char(1)
	Declare @TipoTaxa		VarChar(5)
	Set  @TaxaValor = 0 
	Set  @BaseIRRF = 0 
	Set  @TaxaIRRF = 0 
	Set @TotalBruto = 0 	
	Set @IRRF = 0 
	Set @TotalLiq = 0 
	Set @Limite_Ded_IRRF = IsNull((Select Limite_Ded_IRRF From Referencia Where Ref_Acesso = @Site),0)
	Set @Perc_IRRF = IsNull((Select Perc_IRRF From Referencia Where Ref_Acesso = @Site),0)
			
	If Left(@Num_Proc, 2) = 'EA' 
		Begin 
			Declare CurTaxas Cursor Forward_Only For 
				Select 
					Cta.DC_MEA, Cxa.Vlr_Pgto_Rcto_MEA, Tx.IRRF_Tx, Tx.Cd_Tp_tx
				From 
					Cta_Cte_Mas_Exp_Aer as Cta Join Caixa_Mas_Exp_Aer as Cxa on (Cta.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MEA = Cxa.DC_MEA and Num_Rcb_MEA = @Recibo)
					Left Outer Join Tipo_Taxa as Tx on (Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx)
				Where
					Cta.Num_Proc_MEA = @Num_Proc and 
					Cxa.Num_Rcb_MEA = @Recibo
			
			Open CurTaxas 
			Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
			While @@Fetch_Status = 0 
				Begin 
					If @TaxaDC = 'D'
						Begin
							If @TipoTaxa <>  'IRF'
								Set @TotalBruto = @TotalBruto - @TaxaValor 
						End 
					Else
						Set @TotalBruto = @TotalBruto + @TaxaValor 
					
					If @TaxaIRRF = 'S'
						Set @BaseIRRF = @BaseIRRF + @TaxaValor 
					Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
				End 
				Close CurTaxas 
				Deallocate CurTaxas 
				If @BaseIRRF > @Limite_Ded_IRRF
					Set @TaxaIRRF = (@BaseIRRF * (@Perc_IRRF /100))
				Else
					Set @TaxaIRRF = 0 
				
				Set @TotalLiq	= @TotalBruto - @TaxaIRRF
				
		End 
	If Left(@Num_Proc, 2) = 'EM' 
		Begin 
			Declare CurTaxas Cursor Forward_Only For 
				Select 
					Cta.DC_MEM, Cxa.Vlr_Pgto_Rcto_MEM, Tx.IRRF_Tx, Tx.Cd_Tp_tx
				From 
					Cta_Cte_Mas_Exp_Mar as Cta Join Caixa_Mas_Exp_Mar as Cxa on (Cta.Num_Proc_MEM = Cxa.Num_Proc_MEM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MEM = Cxa.DC_MEM and Num_Rcb_MEM = @Recibo)
					Left Outer Join Tipo_Taxa as Tx on (Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx)
				Where
					Cta.Num_Proc_MEM = @Num_Proc and 
					Cxa.Num_Rcb_MEM = @Recibo
			
			Open CurTaxas 
			Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
			While @@Fetch_Status = 0 
				Begin 
					If @TaxaDC = 'D'
						Begin
							If @TipoTaxa <>  'IRF'
								Set @TotalBruto = @TotalBruto - @TaxaValor 
						End 
					Else
						Set @TotalBruto = @TotalBruto + @TaxaValor 
					
					If @TaxaIRRF = 'S'
						Set @BaseIRRF = @BaseIRRF + @TaxaValor 
					Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
				End 
				Close CurTaxas 
				Deallocate CurTaxas 
				
				If @BaseIRRF > @Limite_Ded_IRRF
					Set @TaxaIRRF = (@BaseIRRF * (@Perc_IRRF /100))
				Else
					Set @TaxaIRRF = 0 
				
				Set @TotalLiq	= @TotalBruto - @TaxaIRRF
				
		End 
	If Left(@Num_Proc, 2) = 'IA' 
		Begin 
			Declare CurTaxas Cursor Forward_Only For 
				Select 
					Cta.DC_MIA, Cxa.Vlr_Pgto_Rcto_MIA, Tx.IRRF_Tx, Tx.Cd_Tp_tx
				From 
					Cta_Cte_Mas_Imp_Aer as Cta Join Caixa_Mas_Imp_Aer as Cxa on (Cta.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MIA = Cxa.DC_MIA and Num_Rcb_MIA = @Recibo)
					Left Outer Join Tipo_Taxa as Tx on (Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx)
				Where
					Cta.Num_Proc_MIA = @Num_Proc and 
					Cxa.Num_Rcb_MIA = @Recibo
			
			Open CurTaxas 
			Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
			While @@Fetch_Status = 0 
				Begin 
					If @TaxaDC = 'D'
						Begin
							If @TipoTaxa <>  'IRF'
								Set @TotalBruto = @TotalBruto - @TaxaValor 
						End 
					Else
						Set @TotalBruto = @TotalBruto + @TaxaValor 
					
					If @TaxaIRRF = 'S'
						Set @BaseIRRF = @BaseIRRF + @TaxaValor 
					Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
				End 
				Close CurTaxas 
				Deallocate CurTaxas 
				
				If @BaseIRRF > @Limite_Ded_IRRF
					Set @TaxaIRRF = (@BaseIRRF * (@Perc_IRRF /100))
				Else
					Set @TaxaIRRF = 0 
				
				Set @TotalLiq	= @TotalBruto - @TaxaIRRF
				
		End 
	If Left(@Num_Proc, 2) = 'IM' 
		Begin 
			Declare CurTaxas Cursor Forward_Only For 
				Select 
					Cta.DC_MIM, Cxa.Vlr_Pgto_Rcto_MIM, Tx.IRRF_Tx, Tx.Cd_Tp_tx
				From 
					Cta_Cte_Mas_Imp_Mar as Cta Join Caixa_Mas_Imp_Mar as Cxa on (Cta.Num_Proc_MIM = Cxa.Num_Proc_MIM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_MIM = Cxa.DC_MIM and Num_Rcb_MIM = @Recibo)
					Left Outer Join Tipo_Taxa as Tx on (Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx)
				Where
					Cta.Num_Proc_MIM = @Num_Proc and 
					Cxa.Num_Rcb_MIM = @Recibo
			
			Open CurTaxas 
			Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
			While @@Fetch_Status = 0 
				Begin 
					If @TaxaDC = 'D'
						Begin
							If @TipoTaxa <>  'IRF'
								Set @TotalBruto = @TotalBruto - @TaxaValor 
						End 
					Else
						Set @TotalBruto = @TotalBruto + @TaxaValor 
					
					If @TaxaIRRF = 'S'
						Set @BaseIRRF = @BaseIRRF + @TaxaValor 
					Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
				End 
				Close CurTaxas 
				Deallocate CurTaxas 
				
				If @BaseIRRF > @Limite_Ded_IRRF
					Set @TaxaIRRF = (@BaseIRRF * (@Perc_IRRF /100))
				Else
					Set @TaxaIRRF = 0 
				
				Set @TotalLiq	= @TotalBruto - @TaxaIRRF
				
		End



GO
