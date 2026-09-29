SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pTotAdiantPO] (
@Processo	varchar(16),
@Total		decimal(12,2) OUTPUT, 
@CredDev	varchar(10) OUTPUT
)
AS
BEGIN
	Set @total = 0 
	if left(@processo, 2) = 'EO' 
		Begin 
			Set @Total = IsNull((Select vlr_org_heo from cta_cte_hou_exp_out cte left join caixa_hou_exp_out cxa on cxa.num_proc_heo = cte.num_proc_heo and cxa.cd_tp_tx = cte.cd_tp_tx and cxa.dc_heo = cte.dc_heo where cte.num_proc_heo = @Processo and cte.cd_tp_tx = 'XBA' and cte.dc_heo = 'C' and cxa.num_proc_heo is null),0)
			Set @CredDev = IsNull((Select distinct cd_cred_dev_hEo From cta_cte_hou_EXP_out cte where cte.num_proc_hEo = @Processo and cte.cd_tp_tx = 'XBA' and cte.dc_heo = 'C'), '')
		end 
	if left(@processo, 2) = 'IO' 
		Begin 
			Set @Total = IsNull((Select vlr_org_hio from cta_cte_hou_imp_out cte left join caixa_hou_imp_out cxa on cxa.num_proc_hio = cte.num_proc_hio and cxa.cd_tp_tx = cte.cd_tp_tx and cxa.dc_hio = cte.dc_hio where cte.num_proc_hio = @Processo and cte.cd_tp_tx = 'XBA' and cte.dc_hio = 'C' and cxa.num_proc_hio is null),0)
			Set @CredDev = IsNull((Select distinct cd_cred_dev_hio From cta_cte_hou_imp_out cte where cte.num_proc_hio = @Processo and cte.cd_tp_tx = 'XBA' and cte.dc_hio = 'C'), '')
		End 
	if left(@processo, 2) = 'EA' 
		Begin 
			Set @Total = IsNull((Select vlr_org_hea from cta_cte_hou_exp_aer cte left join caixa_hou_exp_aer cxa on cxa.num_proc_hea = cte.num_proc_hea and cxa.cd_tp_tx = cte.cd_tp_tx and cxa.dc_hea = cte.dc_hea where cte.num_proc_hea = @Processo and cte.cd_tp_tx = 'XBA' and cte.dc_hea = 'C' and cxa.num_proc_hea is null),0)
			Set @CredDev = IsNull((Select distinct cd_cred_dev_hea From cte.cta_cte_hou_exp_aer cte where cte.num_proc_hea = @Processo and cte.cd_tp_tx = 'XBA' and cte.dc_hea = 'C'), '')
		End 
	if left(@processo, 2) = 'EM' 
		Begin 
			Set @Total = IsNull((Select vlr_org_hem from cta_cte_hou_exp_mar cte left join caixa_hou_exp_mar cxa on cxa.num_proc_hem = cte.num_proc_hem and cxa.cd_tp_tx = cte.cd_tp_tx and cxa.dc_hem = cte.dc_hem where cte.num_proc_hem = @Processo and cte.cd_tp_tx = 'XBA' and cte.dc_hem = 'C' and cxa.num_proc_hem is null),0 )
			Set @CredDev = IsNull((Select distinct cd_cred_dev_hem From cta_cte_hou_exp_mar cte where cte.num_proc_hem = @Processo and cte.cd_tp_tx = 'XBA' and cte.dc_hem = 'C'), '')
		End 

	if left(@processo, 2) = 'IA'	
		Begin 
			Set @Total = IsNull((Select vlr_org_hia from cta_cte_hou_imp_aer cte left join caixa_hou_imp_aer cxa on cxa.num_proc_hia = cte.num_proc_hia and cxa.cd_tp_tx = cte.cd_tp_tx and cxa.dc_hia = cte.dc_hia where cte.num_proc_hia = @Processo and cte.cd_tp_tx = 'XBA' and cte.dc_hia = 'C' and cxa.num_proc_hia is null),0)
			Set @CredDev = IsNull((Select distinct cd_cred_dev_hia From cta_cte_hou_imp_aer cte where cte.num_proc_hia = @Processo and cte.cd_tp_tx = 'XBA' and cte.dc_hia = 'C'), '')
		End
	if left(@processo, 2) = 'IM' 
		Begin 
			Set @Total = IsNull((Select vlr_org_him from cta_cte_hou_imp_mar cte left join caixa_hou_imp_mar cxa on cxa.num_proc_him = cte.num_proc_him and cxa.cd_tp_tx = cte.cd_tp_tx and cxa.dc_him = cte.dc_him where cte.num_proc_him = @Processo and cte.cd_tp_tx = 'XBA' and cte.dc_him = 'C' and cxa.num_proc_him is null),0)
			Set @CredDev = IsNull((Select distinct cd_cred_dev_him From cta_cte_hou_imp_mar cte where cte.num_proc_him = @Processo and cte.cd_tp_tx = 'XBA' and cte.dc_him = 'C'), '')
		End

END

GO
