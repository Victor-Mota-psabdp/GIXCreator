SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[FBusca_DtNota]
(
@Num_Proc Varchar(16)
)
returns Datetime
AS 

BEGIN
	Declare @Valor Datetime
if len(@Num_Proc) = 16
	Begin
	if LEFT(@NUM_PROC,2)='IM'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,emissao,105) from base_nota_fiscal BNF
				left outer join cta_cte_hou_imp_mar CTA on BNF.Nota_Fiscal = CTA.num_Nf_him and BNF.ref_Acesso = CTA.ref_acesso_nf_him 
				Where num_proc_him=@num_proc 
				order by convert(datetime,emissao,105)
				)
		END
	if LEFT(@NUM_PROC,2)='IO'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,emissao,105) from base_nota_fiscal BNF
				left outer join cta_cte_hou_imp_out CTA on BNF.Nota_Fiscal = CTA.num_Nf_hio and BNF.ref_Acesso = CTA.ref_acesso_nf_hio 
				Where num_proc_hio=@num_proc 
				order by convert(datetime,emissao,105)
				)
		
		END
	if LEFT(@NUM_PROC,2)='IA'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,emissao,105) from base_nota_fiscal BNF
				left outer join cta_cte_hou_imp_aer CTA on BNF.Nota_Fiscal = CTA.num_Nf_hia and BNF.ref_Acesso = CTA.ref_acesso_nf_hia 
				Where num_proc_hia=@num_proc 
				order by convert(datetime,emissao,105)
				)
		
		END
	if LEFT(@NUM_PROC,2)='EM'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,emissao,105) from base_nota_fiscal BNF
				left outer join cta_cte_hou_exp_mar CTA on BNF.Nota_Fiscal = CTA.num_Nf_hem and BNF.ref_Acesso = CTA.ref_acesso_nf_hem 
				Where num_proc_hem=@num_proc 
				order by convert(datetime,emissao,105)
				)
		END
	if LEFT(@NUM_PROC,2)='EO'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,emissao,105) from base_nota_fiscal BNF
				left outer join cta_cte_hou_exp_out CTA on BNF.Nota_Fiscal = CTA.num_Nf_heo and BNF.ref_Acesso = CTA.ref_acesso_nf_heo 
				Where num_proc_heo=@num_proc 
				order by convert(datetime,emissao,105)
				)
		
		END
	if LEFT(@NUM_PROC,2)='EA'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,emissao,105) from base_nota_fiscal BNF
				left outer join cta_cte_hou_exp_aer CTA on BNF.Nota_Fiscal = CTA.num_Nf_hea and BNF.ref_Acesso = CTA.ref_acesso_nf_hea 
				Where num_proc_hea=@num_proc 
				order by convert(datetime,emissao,105)
				)
		
		END
End
	else
		Begin
if LEFT(@NUM_PROC,2)='IM'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,emissao,105) from base_nota_fiscal BNF
				left outer join cta_cte_mas_imp_mar CTA on BNF.Nota_Fiscal = CTA.num_Nf_mim and BNF.ref_Acesso = CTA.ref_acesso_nf_mim 
				Where num_proc_mim=@num_proc 
				order by convert(datetime,emissao,105)
				)
		END

	if LEFT(@NUM_PROC,2)='IA'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,emissao,105) from base_nota_fiscal BNF
				left outer join cta_cte_mas_imp_aer CTA on BNF.Nota_Fiscal = CTA.num_Nf_mia and BNF.ref_Acesso = CTA.ref_acesso_nf_mia 
				Where num_proc_mia=@num_proc 
				order by convert(datetime,emissao,105)
				)
		
		END
	if LEFT(@NUM_PROC,2)='EM'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,emissao,105) from base_nota_fiscal BNF
				left outer join cta_cte_mas_exp_mar CTA on BNF.Nota_Fiscal = CTA.num_Nf_mem and BNF.ref_Acesso = CTA.ref_acesso_nf_mem 
				Where num_proc_mem=@num_proc 
				order by convert(datetime,emissao,105)
				)
		END

	if LEFT(@NUM_PROC,2)='EA'
		BEGIN
			set @valor=(
				select top 1 convert(datetime,emissao,105) from base_nota_fiscal BNF
				left outer join cta_cte_mas_exp_aer CTA on BNF.Nota_Fiscal = CTA.num_Nf_mea and BNF.ref_Acesso = CTA.ref_acesso_nf_mea 
				Where num_proc_mea=@num_proc 
				order by convert(datetime,emissao,105)
				)
		
		END
End
		
		return @valor
END




GO
