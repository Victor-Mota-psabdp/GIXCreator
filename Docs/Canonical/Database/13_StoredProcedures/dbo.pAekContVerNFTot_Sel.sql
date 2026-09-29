SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[pAekContVerNFTot_Sel] 
(
	@NF		VarChar(6),
	@Site		Char(1)
)
AS

	Declare @Total		Float
	Set @Total = 0 
	Set @Total = 	IsNull((Select  sum(vlr_pgto_nf_him) total From cta_cte_hou_imp_mar where ref_acesso_nf_him = @Site and Num_nf_him = @NF and dc_him = 'C'), 0) 
	Set @Total = @Total +  IsNull((Select  sum(vlr_pgto_nf_hia) total From cta_cte_hou_imp_aer where ref_acesso_nf_hia = @Site and Num_nf_hia = @NF and dc_hia = 'C'), 0) 
	Set @Total = @Total +  IsNull((Select  sum(vlr_pgto_nf_hio) total From cta_cte_hou_imp_out where ref_acesso_nf_hio = @Site and Num_nf_hio = @NF and dc_hio = 'C'), 0) 
	Set @Total = @Total +  IsNull((Select  sum(vlr_pgto_nf_hem) total From cta_cte_hou_exp_mar where ref_acesso_nf_hem = @Site and Num_nf_hem = @NF and dc_hEm = 'C'), 0) 
	Set @Total = @Total +  IsNull((Select  sum(vlr_pgto_nf_heo) total From cta_cte_hou_exp_out where ref_acesso_nf_heo = @Site and Num_nf_heo = @NF and dc_hEO = 'C'), 0) 
	Set @Total = @Total +  IsNull((Select  sum(vlr_pgto_nf_hea) total From cta_cte_hou_exp_aer where ref_acesso_nf_hea = @Site and Num_nf_hea = @NF and dc_hea = 'C'), 0) 

	Set @Total = @Total +	IsNull((Select  sum(vlr_pgto_nf_mim) total From cta_cte_mas_imp_mar where ref_acesso_nf_mim = @Site and Num_nf_mim = @NF and dc_Mim = 'C'), 0) 
	Set @Total = @Total +  IsNull((Select  sum(vlr_pgto_nf_mia) total From cta_cte_mas_imp_aer where ref_acesso_nf_mia = @Site and Num_nf_mia = @NF and dc_mia = 'C'), 0) 
	Set @Total = @Total +  IsNull((Select  sum(vlr_pgto_nf_mem) total From cta_cte_mas_exp_mar where ref_acesso_nf_mem = @Site and Num_nf_mem = @NF and dc_mem = 'C'), 0) 
	Set @Total = @Total +  IsNull((Select  sum(vlr_pgto_nf_mea) total From cta_cte_mas_exp_aer where ref_acesso_nf_mea = @Site and Num_nf_mea = @NF and dc_mea = 'C'), 0) 


	Set @Total = @Total - IsNull((Select  sum(vlr_pgto_nf_him) total From cta_cte_hou_imp_mar where ref_acesso_nf_him = @Site and Num_nf_him = @NF and dc_him = 'D'), 0) 
	Set @Total = @Total -  IsNull((Select  sum(vlr_pgto_nf_hia) total From cta_cte_hou_imp_aer where ref_acesso_nf_hia = @Site and Num_nf_hia = @NF and dc_hia = 'D'), 0) 
	Set @Total = @Total -  IsNull((Select  sum(vlr_pgto_nf_hio) total From cta_cte_hou_imp_out where ref_acesso_nf_hio = @Site and Num_nf_hio = @NF and dc_hio = 'D'), 0) 
	Set @Total = @Total -  IsNull((Select  sum(vlr_pgto_nf_hem) total From cta_cte_hou_exp_mar where ref_acesso_nf_hem = @Site and Num_nf_hem = @NF and dc_hEm = 'D'), 0) 
	Set @Total = @Total -  IsNull((Select  sum(vlr_pgto_nf_heo) total From cta_cte_hou_exp_out where ref_acesso_nf_heo = @Site and Num_nf_heo = @NF and dc_hEo = 'D'), 0) 
	Set @Total = @Total -  IsNull((Select  sum(vlr_pgto_nf_hea) total From cta_cte_hou_exp_aer where ref_acesso_nf_hea = @Site and Num_nf_hea = @NF and dc_hea = 'D'), 0) 

	Set @Total = @Total -	IsNull((Select  sum(vlr_pgto_nf_mim) total From cta_cte_mas_imp_mar where ref_acesso_nf_mim = @Site and Num_nf_mim = @NF and dc_Mim = 'D'), 0) 
	Set @Total = @Total -  IsNull((Select  sum(vlr_pgto_nf_mia) total From cta_cte_mas_imp_aer where ref_acesso_nf_mia = @Site and Num_nf_mia = @NF and dc_mia = 'D'), 0) 
	Set @Total = @Total -  IsNull((Select  sum(vlr_pgto_nf_mem) total From cta_cte_mas_exp_mar where ref_acesso_nf_mem = @Site and Num_nf_mem = @NF and dc_mem = 'D'), 0) 
	Set @Total = @Total -  IsNull((Select  sum(vlr_pgto_nf_mea) total From cta_cte_mas_exp_aer where ref_acesso_nf_mea = @Site and Num_nf_mea = @NF and dc_mea = 'D'), 0) 

	Select @Total Total




GO
