SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pAekContVerPgtoOrgDst_Sel] 
(
	@PgtRct 		VarChar(14)
)
AS

	Declare @Total		Int
	Set @Total = 0 

	Set @Total = IsNull((Select  count(*) From Caixa_Hou_Imp_Mar Cxa Join Cta_Cte_hou_Imp_Mar Cte on Cte.Num_Proc_HIM = Cxa.Num_Proc_HIM and Cte.DC_HIM = Cxa.DC_HIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx Where (Num_Rcb_HIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Desp_Org_HIM = 'S'),0)
	Set @Total = @Total + IsNull((Select  count(*) From Caixa_Hou_Imp_Aer Cxa Join Cta_Cte_hou_Imp_Aer Cte on Cte.Num_Proc_HIA = Cxa.Num_Proc_HIA and Cte.DC_HIA = Cxa.DC_HIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx Where (Num_Rcb_HIA = @PgtRct or Num_Lcto = @PgtRct ) and Num_Lcto <> 'PROVISÓRIO' and Desp_Org_HIA = 'S'),0)
	Set @Total = @Total + IsNull((Select  count(*) From Caixa_Hou_Imp_Out Cxa Join Cta_Cte_hou_Imp_Out Cte on Cte.Num_Proc_HIO = Cxa.Num_Proc_HIO and Cte.DC_HIO = Cxa.DC_HIO and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx Where (Num_Rcb_HIO = @PgtRct or Num_Lcto = @PgtRct ) and Num_Lcto <> 'PROVISÓRIO' and Desp_Org_HIO = 'S'),0)
	Set @Total = @Total + IsNull((Select  count(*) From Caixa_Hou_Exp_Aer Cxa Join Cta_Cte_hou_Exp_Aer Cte on Cte.Num_Proc_HEA = Cxa.Num_Proc_HEA and Cte.DC_HEA = Cxa.DC_HEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx Where( Num_Rcb_HEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Desp_Dst_HEA = 'S'),0)
	Set @Total = @Total + IsNull((Select  count(*) From Caixa_Hou_Exp_Out Cxa Join Cta_Cte_hou_Exp_Out Cte on Cte.Num_Proc_HEO = Cxa.Num_Proc_HEO and Cte.DC_HEO = Cxa.DC_HEO and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx Where( Num_Rcb_HEO = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Desp_Org_HEO = 'S'),0)
	Set @Total = @Total + IsNull((Select  count(*) From Caixa_Hou_Exp_Mar Cxa Join Cta_Cte_hou_Exp_Mar Cte on Cte.Num_Proc_HEM = Cxa.Num_Proc_HEM and Cte.DC_HEM = Cxa.DC_HEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx Where (Num_Rcb_HEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Desp_Dst_HEM = 'S'),0)

	Set @Total = @Total + IsNull((Select  count(*) From Caixa_Mas_Imp_Mar Cxa Join Cta_Cte_Mas_Imp_Mar Cte on Cte.Num_Proc_MIM = Cxa.Num_Proc_MIM and Cte.DC_MIM = Cxa.DC_MIM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx Where (Num_Rcb_MIM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Desp_Org_MIM = 'S'),0)
	Set @Total = @Total + IsNull((Select  count(*) From Caixa_Mas_Imp_Aer Cxa Join Cta_Cte_Mas_Imp_Aer Cte on Cte.Num_Proc_MIA = Cxa.Num_Proc_MIA and Cte.DC_MIA = Cxa.DC_MIA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx Where (Num_Rcb_MIA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Desp_Org_MIA = 'S'),0)

	Set @Total = @Total + IsNull((Select  count(*) From Caixa_Mas_Exp_Aer Cxa Join Cta_Cte_Mas_Exp_Aer Cte on Cte.Num_Proc_MEA = Cxa.Num_Proc_MEA and Cte.DC_MEA = Cxa.DC_MEA and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx Where (Num_Rcb_MEA = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Desp_Dst_MEA = 'S'),0)
	Set @Total = @Total + IsNull((Select  count(*) From Caixa_Mas_Exp_Mar Cxa Join Cta_Cte_Mas_Exp_Mar Cte on Cte.Num_Proc_MEM = Cxa.Num_Proc_MEM and Cte.DC_MEM = Cxa.DC_MEM and Cte.Cd_Tp_Tx = Cxa.Cd_Tp_Tx Where (Num_Rcb_MEM = @PgtRct or Num_Lcto = @PgtRct) and Num_Lcto <> 'PROVISÓRIO' and Desp_Dst_MEM = 'S'),0)



	Select @Total Total


GO
