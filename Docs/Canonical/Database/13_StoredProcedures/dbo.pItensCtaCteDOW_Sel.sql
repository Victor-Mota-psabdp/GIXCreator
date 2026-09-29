SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pItensCtaCteDOW_Sel]
(
@Processo	varchar(16),
@CredDev	varchar(10),
@NF			varchar(10)
)
AS
BEGIN


	Select cte.dc_hea dc, cte.num_proc_hea processo, cte.cd_tp_Tx, cte.cd_tp_moeda, vlr_org_hea valor, VLR_PC from cta_cte_hou_exp_aer cte left join caixa_hou_exp_aer cxa on cxa.num_proc_hea = cte.num_proc_hea and cxa.dc_hea = cte.dc_hea and cxa.cd_tp_Tx = cte.cd_tp_tx left join fatura_chb_item fat on left(fat.FATURA_CC, 16) = cte.Num_Proc_hea and fat.cd_tp_Tx = cte.cd_tp_tx where (cte.num_nf_hea = @NF or cte.num_nf_hea is null) and cte.num_proc_hea = @Processo and comp_rp_hea = 'S' and cd_cred_dev_hea = @CredDev and cxa.num_proc_hea is null 
	union
	Select cte.dc_hem dc, cte.num_proc_hem processo, cte.cd_tp_Tx, cte.cd_tp_moeda, vlr_org_hem valor, VLR_PC from cta_cte_hou_exp_mar cte left join caixa_hou_exp_mar cxa on cxa.num_proc_hem = cte.num_proc_hem and cxa.dc_hem = cte.dc_hem and cxa.cd_tp_Tx = cte.cd_tp_tx left join fatura_chb_item fat on left(fat.FATURA_CC, 16) = cte.Num_Proc_hem and fat.cd_tp_Tx = cte.cd_tp_tx  where (cte.num_nf_hem = @NF or cte.num_nf_hem is null) and cte.num_proc_hem = @Processo and comp_rp_hem = 'S' and cd_cred_dev_hem = @CredDev and cxa.num_proc_hem is null 
	union
	Select cte.dc_hia dc, cte.num_proc_hia processo, cte.cd_tp_Tx, cte.cd_tp_moeda, vlr_org_hia valor, VLR_PC from cta_cte_hou_imp_aer cte left join caixa_hou_imp_aer cxa on cxa.num_proc_hia = cte.num_proc_hia and cxa.dc_hia = cte.dc_hia and cxa.cd_tp_Tx = cte.cd_tp_tx left join fatura_chb_item fat on left(fat.FATURA_CC, 16) = cte.Num_Proc_hia and fat.cd_tp_Tx = cte.cd_tp_tx where (cte.num_nf_hia = @NF or cte.num_nf_hia is null) and cte.num_proc_hia = @Processo and comp_rp_hia = 'S' and cd_cred_dev_hia = @CredDev and cxa.num_proc_hia is null 
	union
	Select cte.dc_him dc, cte.num_proc_him processo, cte.cd_tp_Tx, cte.cd_tp_moeda, vlr_org_him valor, VLR_PC from cta_cte_hou_imp_mar cte left join caixa_hou_imp_mar cxa on cxa.num_proc_him = cte.num_proc_him and cxa.dc_him = cte.dc_him and cxa.cd_tp_Tx = cte.cd_tp_tx left join fatura_chb_item fat on left(fat.FATURA_CC, 16) = cte.Num_Proc_him and fat.cd_tp_Tx = cte.cd_tp_tx  where (cte.num_nf_him = @NF or cte.num_nf_him is null) and cte.num_proc_him = @Processo and comp_rp_him = 'S' and cd_cred_dev_him = @CredDev and cxa.num_proc_him is null 
	union
	Select cte.dc_heo dc, cte.num_proc_heo processo, cte.cd_tp_Tx, cte.cd_tp_moeda, vlr_org_heo valor, VLR_PC from cta_cte_hou_exp_out cte left join caixa_hou_exp_out cxa on cxa.num_proc_heo = cte.num_proc_heo and cxa.dc_heo = cte.dc_heo and cxa.cd_tp_Tx = cte.cd_tp_tx left join fatura_chb_item fat on left(fat.FATURA_CC, 16) = cte.Num_Proc_heo and fat.cd_tp_Tx = cte.cd_tp_tx  where (cte.num_nf_heo = @NF or cte.num_nf_heo is null) and cte.num_proc_heo = @Processo and comp_rp_heo = 'S' and cd_cred_dev_heo = @CredDev and cxa.num_proc_heo is null 
	union
	Select cte.dc_hio dc, cte.num_proc_hio processo, cte.cd_tp_Tx, cte.cd_tp_moeda, vlr_org_hio valor, VLR_PC from cta_cte_hou_imp_out cte left join caixa_hou_imp_out cxa on cxa.num_proc_hio = cte.num_proc_hio and cxa.dc_hio = cte.dc_hio and cxa.cd_tp_Tx = cte.cd_tp_tx left join fatura_chb_item fat on left(fat.FATURA_CC, 16) = cte.Num_Proc_hio and fat.cd_tp_Tx = cte.cd_tp_tx  where  (cte.num_nf_hio = @NF or cte.num_nf_hio is null) and cte.num_proc_hio = @Processo and comp_rp_hio = 'S' and cd_cred_dev_hio = @CredDev and cxa.num_proc_hio is null

	
END



GO
