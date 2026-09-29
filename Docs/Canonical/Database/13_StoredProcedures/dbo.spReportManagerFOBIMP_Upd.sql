SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spReportManagerFOBIMP_Upd]

	@Num_Proc	Varchar(16)

AS


select cd_proc_cliente ProdID,paridade,sum(Vlr_Total_ITem-isnull(vl_ii,0)-isnull(ACRESCIMOS,0)-isnull(vlr_frete,0)-isnull(vlr_seguro,0)) FOB,sum(Vlr_Total_ITem ) Produto_valor from nota_cliente NC With(NOLOCK)
Join Nota_Fiscal_Cliente_Det NCD With(NOLOCK) on NCD.id_nf=NC.id_nf and NC.cd_cliente=NCD.cd_cliente
Join Produto_Cliente PC With(NOLOCK) on PC.cd_prod=NCD.cd_produto
Where 
	Num_Proc=@Num_Proc
group by cd_proc_cliente,paridade





GO
