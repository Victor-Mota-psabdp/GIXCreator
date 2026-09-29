SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pAekContPgtoTotAdt_Sel] 
(
	@PgtRct 		VarChar(14)
)
AS

	Declare @Total		Decimal(14, 2) 

	Set @Total = 	IsNull((Select  sum(Vlr_Pgto_Rcto_HIM ) From Caixa_Hou_Imp_Mar Cxa Where (Num_Rcb_HIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HIM = 'C'  and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)) ,0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_HIA ) From Caixa_Hou_Imp_Aer Cxa Where (Num_Rcb_HIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HIA = 'C' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_HEA ) From Caixa_Hou_Exp_Aer Cxa Where (Num_Rcb_HEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HEA = 'C' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_HEM ) From Caixa_Hou_Exp_Mar Cxa Where (Num_Rcb_HEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HEM = 'C' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)


	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_MIM ) From Caixa_Mas_Imp_Mar Cxa Where (Num_Rcb_MIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MIM = 'C' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_MIA ) From Caixa_Mas_Imp_Aer Cxa Where (Num_Rcb_MIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MIA = 'C' and Cxa.Cd_tp_Tx  in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_MEA ) From Caixa_Mas_Exp_Aer Cxa Where (Num_Rcb_MEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MEA = 'C' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  sum(Vlr_Pgto_Rcto_MEM ) From Caixa_Mas_Exp_Mar Cxa Where (Num_Rcb_MEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MEM = 'C' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)


	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_HIM ) From Caixa_Hou_Imp_Mar Cxa Where (Num_Rcb_HIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HIM = 'D' and Cxa.Cd_tp_Tx  in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_HIA ) From Caixa_Hou_Imp_Aer Cxa Where (Num_Rcb_HIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HIA = 'D' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_HEA ) From Caixa_Hou_Exp_Aer Cxa Where (Num_Rcb_HEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HEA = 'D' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_HEM ) From Caixa_Hou_Exp_Mar Cxa Where (Num_Rcb_HEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_HEM = 'D' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)


	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_MIM ) From Caixa_Mas_Imp_Mar Cxa Where (Num_Rcb_MIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MIM = 'D' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_MIA ) From Caixa_Mas_Imp_Aer Cxa Where (Num_Rcb_MIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MIA = 'D' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_MEA ) From Caixa_Mas_Exp_Aer Cxa Where (Num_Rcb_MEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MEA = 'D' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total -	IsNull((Select  sum(Vlr_Pgto_Rcto_MEM ) From Caixa_Mas_Exp_Mar Cxa Where (Num_Rcb_MEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and DC_MEM = 'D' and Cxa.Cd_tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)


	Select @Total Total

GO
