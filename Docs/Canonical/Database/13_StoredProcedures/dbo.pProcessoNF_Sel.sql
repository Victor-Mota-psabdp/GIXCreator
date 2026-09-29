SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pProcessoNF_Sel]
(
@NF		varchar(10),
@Site	char(1)
)
AS
BEGIN
	Select distinct cte.num_proc_hea processo from cta_cte_hou_exp_aer cte where cte.num_nf_hea = @nf and ref_acesso_nf_hea = @site 
	union
	Select distinct cte.num_proc_hem processo from cta_cte_hou_exp_mar cte where cte.num_nf_hem = @nf and ref_acesso_nf_hem = @site 
	union
	Select distinct cte.num_proc_hia processo from cta_cte_hou_imp_aer cte where cte.num_nf_hia = @nf and ref_acesso_nf_hia = @site 
	union
	Select distinct cte.num_proc_him processo from cta_cte_hou_imp_mar cte where cte.num_nf_him = @nf and ref_acesso_nf_him = @site 
	union
	Select distinct cte.num_proc_hio processo from cta_cte_hou_imp_out cte where cte.num_nf_hio = @nf and ref_acesso_nf_hio = @site 
	union
	Select distinct cte.num_proc_heo processo from cta_cte_hou_exp_out cte where cte.num_nf_heo = @nf and ref_acesso_nf_heo = @site 
	union
	Select distinct cte.num_proc_mea processo from cta_cte_mas_exp_aer cte where cte.num_nf_mea = @nf and ref_acesso_nf_mea = @site 
	union
	Select distinct cte.num_proc_mem processo from cta_cte_mas_exp_mar cte where cte.num_nf_mem = @nf and ref_acesso_nf_mem = @site 
	union
	Select distinct cte.num_proc_mia processo from cta_cte_mas_imp_aer cte where cte.num_nf_mia = @nf and ref_acesso_nf_mia = @site 
	union
	Select distinct cte.num_proc_mim processo from cta_cte_mas_imp_mar cte where cte.num_nf_mim = @nf and ref_acesso_nf_mim = @site 


END



GO
