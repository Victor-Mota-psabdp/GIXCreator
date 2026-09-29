SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure spKHDA_Siberio_InsUpdDel
	@DE varchar(10),
	@PARA Varchar(10)
	
AS
BEGIN TRANSACTION

Declare @Emissao datetime




-- Apagar DE Fatura_Arg e Base_NotaFiscal

delete fatura_arg_det where id_fat in (select id_fat from fatura_arg where numero=@PARA and codigo='B')
Delete Fatura_Arg where numero=@PARA and codigo='B'
set @Emissao =(select emissao from base_nota_fiscal where nota_fiscal = @PARA)
Delete Base_Nota_Fiscal where nota_fiscal=@PARA and ref_acesso='B'

-- Atualizar

Update fatura_arg set numero=@PARA where numero=@DE and codigo='B'
Update base_nota_fiscal set nota_fiscal=@para, emissao = @Emissao where nota_fiscal=@DE and ref_acesso='B'
Update cta_cte_hou_imp_mar set num_nf_him=@Para where num_nf_him=@DE and ref_acesso_nf_him='B'
Update cta_cte_hou_imp_aer set num_nf_hia=@Para where num_nf_hia=@DE and ref_acesso_nf_hia='B'
Update cta_cte_hou_imp_out set num_nf_hio=@Para where num_nf_hio=@DE and ref_acesso_nf_hio='B'
Update cta_cte_hou_exp_mar set num_nf_hem=@Para where num_nf_hem=@DE and ref_acesso_nf_hem='B'
Update cta_cte_hou_exp_aer set num_nf_hea=@Para where num_nf_hea=@DE and ref_acesso_nf_hea='B'
Update cta_cte_hou_exp_out set num_nf_heo=@Para where num_nf_heo=@DE and ref_acesso_nf_heo='B'
Update cta_cte_mas_imp_mar set num_nf_mim=@Para where num_nf_mim=@DE and ref_acesso_nf_mim='B'
Update cta_cte_mas_exp_mar set num_nf_mem=@Para where num_nf_mem=@DE and ref_acesso_nf_mem='B'
Update cta_cte_mas_imp_aer set num_nf_mia=@Para where num_nf_mia=@DE and ref_acesso_nf_mia='B'
Update ctA_cte_mas_exp_aer set num_nf_mea=@Para where num_nf_mea=@DE and ref_acesso_nf_mea='B'


	IF @@ERROR <> 0
		BEGIN
			RETURN -1
		END
COMMIT TRANSACTION
GO
