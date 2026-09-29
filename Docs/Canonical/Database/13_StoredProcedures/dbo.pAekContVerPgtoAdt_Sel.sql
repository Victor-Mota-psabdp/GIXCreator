SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pAekContVerPgtoAdt_Sel] 
(
	@PgtRct 		VarChar(14)
)
AS

	Declare @Total		Int
	Declare @TotalNAdt 		Int

	Set @Total = 	IsNull((Select  count(*) From Caixa_Hou_Imp_Mar Cxa Where (Num_Rcb_HIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Hou_Imp_Aer Cxa Where (Num_Rcb_HIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Hou_Exp_Mar Cxa Where (Num_Rcb_HEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Hou_Exp_Aer  Cxa Where (Num_Rcb_HEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)


	Set @Total = @Total +   IsNull((Select  count(*) From Caixa_Mas_Imp_Mar Cxa Where (Num_Rcb_MIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Mas_Imp_Aer Cxa Where (Num_Rcb_MIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Mas_Exp_Mar Cxa Where (Num_Rcb_MEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Mas_Exp_Aer  Cxa Where (Num_Rcb_MEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)


	Set @TotalNAdt = 	IsNull((Select  count(*) From Caixa_Hou_Imp_Mar Cxa Where (Num_Rcb_HIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @TotalNAdt = @TotalNAdt +	IsNull((Select  count(*) From Caixa_Hou_Imp_Aer Cxa Where (Num_Rcb_HIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @TotalNAdt = @TotalNAdt +	IsNull((Select  count(*) From Caixa_Hou_Exp_Mar Cxa Where (Num_Rcb_HEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @TotalNAdt = @TotalNAdt +	IsNull((Select  count(*) From Caixa_Hou_Exp_Aer  Cxa Where (Num_Rcb_HEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)


	Set @TotalNAdt = @TotalNAdt +   IsNull((Select  count(*) From Caixa_Mas_Imp_Mar Cxa Where (Num_Rcb_MIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @TotalNAdt = @TotalNAdt +	IsNull((Select  count(*) From Caixa_Mas_Imp_Aer Cxa Where (Num_Rcb_MIA = @PgtRct or Num_Lcto = @PgtRct ) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @TotalNAdt = @TotalNAdt +	IsNull((Select  count(*) From Caixa_Mas_Exp_Mar Cxa Where (Num_Rcb_MEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @TotalNAdt = @TotalNAdt +	IsNull((Select  count(*) From Caixa_Mas_Exp_Aer  Cxa Where (Num_Rcb_MEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and cd_Tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)


	If @Total > 0 and @TotalNAdt > 0 
		Select 2 Total
	else 
		Select 0 Total

GO
