SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pTotTaxasForaNF_Sel]
(
@NF			varchar(10),
@Site		char(1),
@CredDev	varchar(10),
@Processo	varchar(16)
)
AS
BEGIN
	Declare @TotalImp 	Float
	Set @TotalImp  = 0 
	Set @TotalImp = @TotalImp + IsNull((Select sum(vlr_org_hea) from cta_cte_hou_exp_aer cte left join caixa_hou_exp_aer cxa on cxa.num_proc_hea = cte.num_proc_hea and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_hea = cte.dc_hea where cte.num_proc_hea = @Processo and cte.cd_cred_dev_hea = @CredDev and cxa.num_proc_hea is null and cte.num_nf_hea is null and cte.dc_hea = 'C' and cte.cd_tp_moeda = 'REL' and cte.cd_tp_tx <> 'XBA' and cte.cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(vlr_org_hem) from cta_cte_hou_exp_mar cte left join caixa_hou_exp_mar cxa on cxa.num_proc_hem = cte.num_proc_hem and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_hem = cte.dc_hem where cte.num_proc_hem = @Processo and  cte.cd_cred_dev_hem = @CredDev and cxa.num_proc_hem is null and cte.num_nf_hem is null and cte.dc_hem = 'C' and cte.cd_tp_moeda = 'REL' and cte.cd_tp_tx <> 'XBA' and cte.cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(vlr_org_hia) from cta_cte_hou_imp_aer cte left join caixa_hou_imp_aer cxa on cxa.num_proc_hia = cte.num_proc_hia and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_hia = cte.dc_hia where cte.num_proc_hia = @Processo and cte.cd_cred_dev_hia = @CredDev and cxa.num_proc_hia is null and cte.num_nf_hia is null and cte.dc_hia = 'C' and cte.cd_tp_moeda = 'REL' and cte.cd_tp_tx <> 'XBA' and cte.cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(vlr_org_him) from cta_cte_hou_imp_mar cte left join caixa_hou_imp_mar cxa on cxa.num_proc_him = cte.num_proc_him and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_him = cte.dc_him where cte.num_proc_him = @Processo and cte.cd_cred_dev_him = @CredDev and cxa.num_proc_him is null and cte.num_nf_him is null and cte.dc_him = 'C' and cte.cd_tp_moeda = 'REL' and cte.cd_tp_tx <> 'XBA' and cte.cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(vlr_org_heo) from cta_cte_hou_exp_out cte left join caixa_hou_exp_out cxa on cxa.num_proc_heo = cte.num_proc_heo and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_heo = cte.dc_heo where cte.num_proc_heo = @Processo and cte.cd_cred_dev_heo = @CredDev and cxa.num_proc_heo is null and cte.num_nf_heo is null and cte.dc_heo = 'C' and cte.cd_tp_moeda = 'REL' and cte.cd_tp_tx <> 'XBA' and cte.cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(vlr_org_hio) from cta_cte_hou_imp_out cte left join caixa_hou_imp_out cxa on cxa.num_proc_hio = cte.num_proc_hio and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_hio = cte.dc_hio where cte.num_proc_hio = @Processo and cte.cd_cred_dev_hio = @CredDev and cxa.num_proc_hio is null and cte.num_nf_hio is null and cte.dc_hio = 'C' and cte.cd_tp_moeda = 'REL' and cte.cd_tp_tx <> 'XBA' and cte.cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)


	Set @TotalImp = @TotalImp + IsNull((Select sum(VLR_PC) from cta_cte_hou_exp_aer cte left join caixa_hou_exp_aer cxa on cxa.num_proc_hea = cte.num_proc_hea and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_hea = cte.dc_hea left join fatura_chb_item fat on left(fat.FATURA_CC, 16) = cte.Num_Proc_hea and fat.cd_tp_tx = cte.cd_Tp_tx where cte.num_proc_hea = @Processo and  cte.cd_cred_dev_hea = @CredDev and cxa.num_proc_hea is null and cte.num_nf_hea is null and cte.dc_hea = 'C' and cte.cd_tp_moeda <> 'REL' and cte.cd_tp_tx <> 'XBA' and cte.cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(VLR_PC) from cta_cte_hou_exp_mar cte left join caixa_hou_exp_mar cxa on cxa.num_proc_hem = cte.num_proc_hem and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_hem = cte.dc_hem left join fatura_chb_item fat on left(fat.FATURA_CC, 16) = cte.Num_Proc_hem and fat.cd_tp_tx = cte.cd_Tp_tx where cte.num_proc_hem = @Processo and cte.cd_cred_dev_hem = @CredDev and cxa.num_proc_hem is null and cte.num_nf_hem is null and cte.dc_hem = 'C' and cte.cd_tp_moeda <> 'REL' and cte.cd_tp_tx <> 'XBA' and cte.cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(VLR_PC) from cta_cte_hou_imp_aer cte left join caixa_hou_imp_aer cxa on cxa.num_proc_hia = cte.num_proc_hia and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_hia = cte.dc_hia left join fatura_chb_item fat on left(fat.FATURA_CC, 16) = cte.Num_Proc_hia and fat.cd_tp_tx = cte.cd_Tp_tx where cte.num_proc_hia = @Processo and  cte.cd_cred_dev_hia = @CredDev and cxa.num_proc_hia is null and cte.num_nf_hia is null and cte.dc_hia = 'C' and cte.cd_tp_moeda <> 'REL' and cte.cd_tp_tx <> 'XBA' and cte.cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(VLR_PC) from cta_cte_hou_imp_mar cte left join caixa_hou_imp_mar cxa on cxa.num_proc_him = cte.num_proc_him and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_him = cte.dc_him left join fatura_chb_item fat on left(fat.FATURA_CC, 16) = cte.Num_Proc_him and fat.cd_tp_tx = cte.cd_Tp_tx where cte.num_proc_him = @Processo and cte.cd_cred_dev_him = @CredDev and cxa.num_proc_him is null and cte.num_nf_him is null and cte.dc_him = 'C' and cte.cd_tp_moeda <> 'REL' and cte.cd_tp_tx <> 'XBA' and cte.cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(VLR_PC) from cta_cte_hou_exp_out cte left join caixa_hou_exp_out cxa on cxa.num_proc_heo = cte.num_proc_heo and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_heo = cte.dc_heo left join fatura_chb_item fat on left(fat.FATURA_CC, 16) = cte.Num_Proc_heo and fat.cd_tp_tx = cte.cd_Tp_tx where cte.num_proc_heo = @Processo and cte.cd_cred_dev_heo = @CredDev and cxa.num_proc_heo is null and cte.num_nf_heo is null and cte.dc_heo = 'C' and cte.cd_tp_moeda <> 'REL' and cte.cd_tp_tx <> 'XBA' and cte.cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(VLR_PC) from cta_cte_hou_imp_out cte left join caixa_hou_imp_out cxa on cxa.num_proc_hio = cte.num_proc_hio and cxa.cd_tp_Tx = cte.cd_tp_Tx and cxa.dc_hio = cte.dc_hio left join fatura_chb_item fat on left(fat.FATURA_CC, 16) = cte.Num_Proc_hio and fat.cd_tp_tx = cte.cd_Tp_tx where cte.num_proc_hio = @Processo and cte.cd_cred_dev_hio = @CredDev and cxa.num_proc_hio is null and cte.num_nf_hio is null and cte.dc_hio = 'C' and cte.cd_tp_moeda <> 'REL' and cte.cd_tp_tx <> 'XBA' and cte.cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)


	Select @TotalImp Total

END
GO
