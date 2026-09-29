SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[pAekContVerPgtoTot_Sel] 
(
	@PgtRct 		VarChar(14)
)
AS

	Declare @Total		Decimal(12,2)

	Set @Total = 	IsNull((Select  sum(Vlr_Pgto_Rcto_HIM ) From Caixa_Hou_Imp_Mar Cxa Where (Num_Rcb_HIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HIM = 'C'  ) ,0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_HIA ) From Caixa_Hou_Imp_Aer Cxa Where (Num_Rcb_HIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HIA = 'C' ),0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_HIO ) From Caixa_Hou_Imp_Out Cxa Where (Num_Rcb_HIO = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HIO = 'C' ),0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_HEA ) From Caixa_Hou_Exp_Aer Cxa Where (Num_Rcb_HEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HEA = 'C' ),0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_HEO ) From Caixa_Hou_Exp_Out Cxa Where (Num_Rcb_HEO = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HEO = 'C' ),0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_HEM ) From Caixa_Hou_Exp_Mar Cxa Where (Num_Rcb_HEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HEM = 'C' ),0)


	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_MIM ) From Caixa_Mas_Imp_Mar Cxa Where (Num_Rcb_MIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MIM = 'C' ),0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_MIA ) From Caixa_Mas_Imp_Aer Cxa Where (Num_Rcb_MIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MIA = 'C' ),0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_MEA ) From Caixa_Mas_Exp_Aer Cxa Where (Num_Rcb_MEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MEA = 'C' ),0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_MEM ) From Caixa_Mas_Exp_Mar Cxa Where (Num_Rcb_MEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MEM = 'C' ),0)


	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_HIM ) From Caixa_Hou_Imp_Mar Cxa Where (Num_Rcb_HIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HIM = 'D' ),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_HIA ) From Caixa_Hou_Imp_Aer Cxa Where (Num_Rcb_HIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HIA = 'D' ),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_HIO ) From Caixa_Hou_Imp_Out Cxa Where (Num_Rcb_HIO = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HIO = 'D' ),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_HEA ) From Caixa_Hou_Exp_Aer Cxa Where (Num_Rcb_HEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HEA = 'D' ),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_HEO ) From Caixa_Hou_Exp_Out Cxa Where (Num_Rcb_HEO = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HEO = 'D' ),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_HEM ) From Caixa_Hou_Exp_Mar Cxa Where (Num_Rcb_HEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HEM = 'D' ),0)


	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_MIM ) From Caixa_Mas_Imp_Mar Cxa Where (Num_Rcb_MIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MIM = 'D' ),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_MIA ) From Caixa_Mas_Imp_Aer Cxa Where (Num_Rcb_MIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MIA = 'D' ),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_MEA ) From Caixa_Mas_Exp_Aer Cxa Where (Num_Rcb_MEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MEA = 'D' ),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_MEM ) From Caixa_Mas_Exp_Mar Cxa Where (Num_Rcb_MEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MEM = 'D' ),0)


	Select @Total Total
GO
