SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[spNotaFiscalDET]
	@Num_Proc	Varchar(16)
AS


select cd_proc_cliente GMID,sum(quantidadE) qTY, sum(Vlr_total_Item) Valor from nota_cliente NC With(nolock)
Join nota_fiscal_cliente_Det NDD With(nolock) on NDD.id_NF=NC.ID_NF and NDD.cd_cliente=NC.cd_cliente
Join Produto_Cliente PC With(nolock) on PC.cd_prod=Cd_produto
Where num_proc=@num_proc
group by cd_proc_cliente

GO
