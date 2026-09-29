SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spReportManagerFOB_Upd]

	@Num_Proc	Varchar(16)

AS


select cd_proc_cliente ProdID,paridade,sum(Vlr_Total_ITem-isnull(vlr_frete,0)-isnull(vlr_seguro,0)-isnull(vl_ii,0)-isnull(ACRESCIMOS,0)) FOB from nota_cliente NC with(nolock)
Join Nota_Fiscal_Cliente_Det NCD with(nolock) on NCD.id_nf=NC.id_nf and NC.cd_cliente=NCD.cd_cliente
Join Produto_Cliente PC with(nolock) on PC.cd_prod=NCD.cd_produto
Where 
	Num_Proc=@Num_Proc
group by cd_proc_cliente,paridade




GO
