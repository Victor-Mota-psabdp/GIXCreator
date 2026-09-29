SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pAekContVerPgtoMes_Sel] 
(
	@PgtRct 		VarChar(14)
)
AS

	Declare @Total		Decimal(14, 2) 

	Set @Total = 	IsNull((Select  count(*) From Caixa_Hou_Imp_Mar Cxa Join Cta_Cte_Hou_Imp_Mar Cte on Cte.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HIM = Cxa.DC_HIM Where  (dbo.fLastDayMonth(Right(Cte.Dt_Ins_HIM, 7))  > convert(Datetime, dbo.fLastDayMonth(Right(Cxa.Dt_Pgto_Rcto_HIM, 7)), 105))  and (Num_Rcb_HIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO'  and Cxa.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)) ,0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Hou_Imp_Aer Cxa Join Cta_Cte_Hou_Imp_Aer Cte on Cte.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HIA = Cxa.DC_HIA  Where (dbo.fLastDayMonth(Right(Cte.Dt_Ins_HIA, 7))  > convert(Datetime, dbo.fLastDayMonth(Right(Cxa.Dt_Pgto_Rcto_HIA, 7)), 105)) and (Num_Rcb_HIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Cxa.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Hou_Imp_Out Cxa Join Cta_Cte_Hou_Imp_Out Cte on Cte.Num_Proc_HIO = Cxa.Num_Proc_HIO and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HIO = Cxa.DC_HIO  Where (dbo.fLastDayMonth(Right(Cte.Dt_Ins_HIO, 7))  > convert(Datetime, dbo.fLastDayMonth(Right(Cxa.Dt_Pgto_Rcto_HIO, 7)), 105)) and (Num_Rcb_HIO = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Cxa.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Hou_Exp_Aer Cxa Join Cta_Cte_Hou_Exp_Aer Cte on Cte.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HEA = Cxa.DC_HEA  Where (dbo.fLastDayMonth(Right(Cte.Dt_Ins_HEA, 7))  > convert(Datetime, dbo.fLastDayMonth(Right(Cxa.Dt_Pgto_Rcto_HEA, 7)), 105)) and (Num_Rcb_HEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO'  and Cxa.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Hou_Exp_Out Cxa Join Cta_Cte_Hou_Exp_Out Cte on Cte.Num_Proc_HEO = Cxa.Num_Proc_HEO and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HEO = Cxa.DC_HEO  Where (dbo.fLastDayMonth(Right(Cte.Dt_Ins_HEO, 7))  > convert(Datetime, dbo.fLastDayMonth(Right(Cxa.Dt_Pgto_Rcto_HEO, 7)), 105)) and (Num_Rcb_HEO = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO'  and Cxa.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Hou_Exp_Mar Cxa Join Cta_Cte_Hou_Exp_Mar Cte on Cte.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_HEM = Cxa.DC_HEM  Where ( dbo.fLastDayMonth(Right(Cte.Dt_Ins_HEM, 7))  > convert(Datetime, dbo.fLastDayMonth(Right(Cxa.Dt_Pgto_Rcto_HEM, 7)), 105))  and (Num_Rcb_HEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Cxa.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)


	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Mas_Imp_Mar Cxa Join Cta_Cte_Mas_Imp_Mar Cte on Cte.Num_Proc_MIM = Cxa.Num_Proc_MIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_MIM = Cxa.DC_MIM Where (dbo.fLastDayMonth(Right(Cte.Dt_Ins_MIM, 7))  > convert(Datetime, dbo.fLastDayMonth(Right(Cxa.Dt_Pgto_Rcto_MIM, 7)), 105)) and  (Num_Rcb_MIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Cxa.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Mas_Imp_Aer Cxa Join Cta_Cte_Mas_Imp_Aer Cte on Cte.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_MIA = Cxa.DC_MIA Where ( dbo.fLastDayMonth(Right(Cte.Dt_Ins_MIA, 7))  > convert(Datetime, dbo.fLastDayMonth(Right(Cxa.Dt_Pgto_Rcto_MIA, 7)), 105)) and  (Num_Rcb_MIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Cxa.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Mas_Exp_Aer Cxa Join Cta_Cte_Mas_Exp_Aer Cte on Cte.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_MEA = Cxa.DC_MEA Where ( dbo.fLastDayMonth(Right(Cte.Dt_Ins_MEA, 7))  > convert(Datetime, dbo.fLastDayMonth(Right(Cxa.Dt_Pgto_Rcto_MEA, 7)), 105)) and  (Num_Rcb_MEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Cxa.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)
	Set @Total = @Total +	IsNull((Select  count(*) From Caixa_Mas_Exp_Mar Cxa Join Cta_Cte_Mas_Exp_Mar Cte on Cte.Num_Proc_MEM = Cxa.Num_Proc_MEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx and Cte.DC_MEM = Cxa.DC_MEM Where ( dbo.fLastDayMonth(Right(Cte.Dt_Ins_MEM, 7))  > convert(Datetime, dbo.fLastDayMonth(Right(Cxa.Dt_Pgto_Rcto_MEM, 7)), 105)) and (Num_Rcb_MEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO'  and Cxa.Cd_tp_Tx not in (select cd_tp_Tx from Param_AEKContabil_Taxas_Exc)),0)

	Select @Total Total



GO
