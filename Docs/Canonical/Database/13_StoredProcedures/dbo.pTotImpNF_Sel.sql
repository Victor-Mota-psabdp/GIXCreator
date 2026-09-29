SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pTotImpNF_Sel]
(
@Processo	varchar(16),
@CredDev	varchar(10),
@TotalImp 	decimal(12,2) = 0 OUTPUT
)
AS
BEGIN
	
	Set @TotalImp  = 0 
	Set @TotalImp = @TotalImp + IsNull((Select sum(VLR_ORG_HEA) from cta_cte_hou_exp_aer cte left join caixa_hou_exp_aer cxa on cxa.num_proc_hea = cte.num_proc_hea and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_hea = cte.dc_hea where cd_cred_dev_hea = @CredDev and cte.dc_hea = 'D' and cxa.num_proc_hea is null and cte.num_proc_hea = @Processo and cte.cd_tp_tx in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(VLR_ORG_HEM) from cta_cte_hou_exp_mar cte left join caixa_hou_exp_mar cxa on cxa.num_proc_hem = cte.num_proc_hem and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_hem = cte.dc_hem where cd_cred_dev_hem = @CredDev and cte.dc_hem = 'D' and cxa.num_proc_hem is null and cte.num_proc_hem = @Processo and cte.cd_tp_tx in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(VLR_ORG_HIA) from cta_cte_hou_imp_aer cte left join caixa_hou_imp_aer cxa on cxa.num_proc_hia = cte.num_proc_hia and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_hia = cte.dc_hia where cd_cred_dev_hia = @CredDev and cte.dc_hia = 'D' and cxa.num_proc_hia is null and cte.num_proc_hia = @Processo and cte.cd_tp_tx in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(VLR_ORG_HIM) from cta_cte_hou_imp_mar cte left join caixa_hou_imp_mar cxa on cxa.num_proc_him = cte.num_proc_him and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_him = cte.dc_him where cd_cred_dev_him = @CredDev and cte.dc_him = 'D' and cxa.num_proc_him is null and cte.num_proc_him = @Processo and cte.cd_tp_tx in (select cd_tp_tx from taxas_impostos_nf)),0)

	Set @TotalImp = @TotalImp + IsNull((Select sum(VLR_ORG_HIO) from cta_cte_hou_imp_out cte left join caixa_hou_imp_out cxa on cxa.num_proc_hio = cte.num_proc_hio and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_hio = cte.dc_hio where cd_cred_dev_hio = @CredDev and cte.dc_hio = 'D' and cxa.num_proc_hio is null and cte.num_proc_hio = @Processo and cte.cd_tp_tx in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(VLR_ORG_HEO) from cta_cte_hou_exp_out cte left join caixa_hou_exp_out cxa on cxa.num_proc_heo = cte.num_proc_heo and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_heo = cte.dc_heo where cd_cred_dev_heo = @CredDev and cxa.num_proc_heo is null and cte.num_proc_heo = @Processo and  cte.cd_tp_tx in (select cd_tp_tx from taxas_impostos_nf)),0)


	Select @TotalImp Total


END
GO
