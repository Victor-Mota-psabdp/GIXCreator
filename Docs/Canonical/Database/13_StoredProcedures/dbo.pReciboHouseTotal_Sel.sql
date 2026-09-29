SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pReciboHouseTotal_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE [dbo].[pReciboHouseTotal_Sel]
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
					Cta.DC_HEA, Cxa.Vlr_Pgto_Rcto_HEA, Tx.IRRF_Tx, Tx.Cd_Tp_tx
				From 
					Cta_Cte_Hou_Exp_Aer as Cta Join Caixa_Hou_Exp_Aer as Cxa on (Cta.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEA = Cxa.DC_HEA and Num_Rcb_HEA = @Recibo)
					Left Outer Join Tipo_Taxa as Tx on (Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx)
				Where
					Cta.Num_Proc_HEA = @Num_Proc and 
					Cxa.Num_Rcb_HEA = @Recibo
			
			Open CurTaxas 
			Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
			While @@Fetch_Status = 0 
				Begin 
					If @TaxaDC = 'D'
						Begin
							--If @TipoTaxa <>  'IRF'
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
					Cta.DC_HEM, Cxa.Vlr_Pgto_Rcto_HEM, Tx.IRRF_Tx, Tx.Cd_Tp_tx
				From 
					Cta_Cte_Hou_Exp_Mar as Cta Join Caixa_Hou_Exp_Mar as Cxa on (Cta.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEM = Cxa.DC_HEM and Num_Rcb_HEM = @Recibo)
					Left Outer Join Tipo_Taxa as Tx on (Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx)
				Where
					Cta.Num_Proc_HEM = @Num_Proc and 
					Cxa.Num_Rcb_HEM = @Recibo
			
			Open CurTaxas 
			Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
			While @@Fetch_Status = 0 
				Begin 
					If @TaxaDC = 'D'
						Begin
							--If @TipoTaxa <>  'IRF'
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
					Cta.DC_HIA, Cxa.Vlr_Pgto_Rcto_HIA, Tx.IRRF_Tx, Tx.Cd_Tp_tx
				From 
					Cta_Cte_Hou_Imp_Aer as Cta Join Caixa_Hou_Imp_Aer as Cxa on (Cta.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIA = Cxa.DC_HIA and Num_Rcb_HIA = @Recibo)
					Left Outer Join Tipo_Taxa as Tx on (Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx)
				Where
					Cta.Num_Proc_HIA = @Num_Proc and 
					Cxa.Num_Rcb_HIA = @Recibo
			
			Open CurTaxas 
			Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
			While @@Fetch_Status = 0 
				Begin 
					If @TaxaDC = 'D'
						Begin
							--If @TipoTaxa <>  'IRF'
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
					Cta.DC_HIM, Cxa.Vlr_Pgto_Rcto_HIM, Tx.IRRF_Tx, Tx.Cd_Tp_tx
				From 
					Cta_Cte_Hou_Imp_Mar as Cta Join Caixa_Hou_Imp_Mar as Cxa on (Cta.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIM = Cxa.DC_HIM and Num_Rcb_HIM = @Recibo)
					Left Outer Join Tipo_Taxa as Tx on (Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx)
				Where
					Cta.Num_Proc_HIM = @Num_Proc and 
					Cxa.Num_Rcb_HIM = @Recibo
			
			Open CurTaxas 
			Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
			While @@Fetch_Status = 0 
				Begin 
					If @TaxaDC = 'D'
						Begin
							--If @TipoTaxa <>  'IRF'
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


	If Left(@Num_Proc, 2) = 'IO' 
		Begin 
			Declare CurTaxas Cursor Forward_Only For 
				Select 
					Cta.DC_HIO, Cxa.Vlr_Pgto_Rcto_HIO, Tx.IRRF_Tx, Tx.Cd_Tp_tx
				From 
					Cta_Cte_Hou_Imp_Out as Cta Join Caixa_Hou_Imp_Out as Cxa on (Cta.Num_Proc_HIO = Cxa.Num_Proc_HIO and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HIO = Cxa.DC_HIO and Num_Rcb_HIO = @Recibo)
					Left Outer Join Tipo_Taxa as Tx on (Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx)
				Where
					Cta.Num_Proc_HIO = @Num_Proc and 
					Cxa.Num_Rcb_HIO = @Recibo
			
			Open CurTaxas 
			Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
			While @@Fetch_Status = 0 
				Begin 
					If @TaxaDC = 'D'
						Begin
							--If @TipoTaxa <>  'IRF'
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

	If Left(@Num_Proc, 2) = 'EO' 
		Begin 
			Declare CurTaxas Cursor Forward_Only For 
				Select 
					Cta.DC_HEO, Cxa.Vlr_Pgto_Rcto_HEO, Tx.IRRF_Tx, Tx.Cd_Tp_tx
				From 
					Cta_Cte_Hou_Exp_Out as Cta Join Caixa_Hou_Exp_Out as Cxa on (Cta.Num_Proc_HEO = Cxa.Num_Proc_HEO and Cta.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cta.DC_HEO = Cxa.DC_HEO and Num_Rcb_HEO = @Recibo)
					Left Outer Join Tipo_Taxa as Tx on (Cta.Cd_Tp_Tx = Tx.Cd_Tp_Tx)
				Where
					Cta.Num_Proc_HEO = @Num_Proc and 
					Cxa.Num_Rcb_HEO = @Recibo
			
			Open CurTaxas 
			Fetch Next From CurTaxas Into @TaxaDC,@TaxaValor, @TaxaIRRF, @TipoTaxa
			While @@Fetch_Status = 0 
				Begin 
					If @TaxaDC = 'D'
						Begin
							--If @TipoTaxa <>  'IRF'
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
--pRINT @TotalBruto		
--PRINT  @IRRF			
--PRINT @TotalLiq
--return

GO
