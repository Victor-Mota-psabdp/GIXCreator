SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pTotTaxasNF_Sel]
(
@NF		varchar(10),
@Site	char(1), 
@CredDev	varchar(10)
)
AS
BEGIN
	Declare @totalImp Float

	Set @TotalImp  = 0 
	Set @TotalImp = @TotalImp + IsNull((Select sum(vlr_pgto_nf_hea) from cta_cte_hou_exp_aer where cd_cred_dev_hea = @CredDev and num_nf_hea = @nf and ref_acesso_nf_hea = @site and dc_hea = 'C' and cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(vlr_pgto_nf_hem) from cta_cte_hou_exp_mar where cd_cred_dev_hem = @CredDev and num_nf_hem = @nf and ref_acesso_nf_hem = @site and dc_hem = 'C' and cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(vlr_pgto_nf_hia) from cta_cte_hou_imp_aer where cd_cred_dev_hia = @CredDev and num_nf_hia = @nf and ref_acesso_nf_hia = @site and dc_hia = 'C' and cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(vlr_pgto_nf_him) from cta_cte_hou_imp_mar where cd_cred_dev_him = @CredDev and num_nf_him = @nf and ref_acesso_nf_him = @site and dc_him = 'C' and cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)

	Set @TotalImp = @TotalImp + IsNull((Select sum(vlr_pgto_nf_heo) from cta_cte_hou_exp_out where cd_cred_dev_heo = @CredDev and num_nf_heo = @nf and ref_acesso_nf_heo = @site and dc_heo = 'C' and cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)
	Set @TotalImp = @TotalImp + IsNull((Select sum(vlr_pgto_nf_hio) from cta_cte_hou_imp_out where cd_cred_dev_hio = @CredDev and num_nf_hio = @nf and ref_acesso_nf_hio = @site and dc_hio = 'C' and cd_tp_tx not in (select cd_tp_tx from taxas_impostos_nf)),0)


	Select @TotalImp Total

END


GO
