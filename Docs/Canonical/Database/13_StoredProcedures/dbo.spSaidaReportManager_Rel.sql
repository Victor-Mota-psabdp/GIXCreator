SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spSaidaReportManager_Rel] --'IMCSR201410514BR'

	@Num_Proc Varchar(16)
	

as


select distinct num_proc,cd_proc_cliente,CFOP,vl_aliq_pis Ali_PIS,Aliq_IPI,VL_ALIQ_COFINS VL_ALIQ_COFINS,ALIQ_ICMS,Aliq_II from nota_cliente NC with(nolock)
Join Nota_Fiscal_Cliente_det NCD with(nolock) on NCD.id_nf=NC.id_nf and NCD.cd_cliente=NC.cd_cliente
Join Produto_Cliente PC on PC.cd_prod=cd_produto
Where
	Num_Proc=@Num_Proc
	


GO
