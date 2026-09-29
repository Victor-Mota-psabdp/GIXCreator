SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PRocedure [dbo].[spBuscaProcessoFMCImp06Itens_Sel]
	@num_proc	Varchar(16),
	@item		varchar(10),
	@num_nf		Varchar(40)
AS

SELECT CFOP,Cd_Proc_Cliente Material,Quantidade,Vlr_Total_Item,NCM FROM NOTA_CLIENTE NC with(nolock)
Join Nota_Fiscal_Cliente_Det NDD with(nolock) on NC.id_nf=NDD.id_nf and NC.cd_cliente=NDD.cd_cliente
Join Pedido_Ship PS with(nolock) on PS.num_proc=nc.num_proc and ps.cd_produto=NDD.cd_produto
Join Produto_Cliente PC with(nolock) on PC.cd_prod=PS.cd_produto
Where envio is null and nc.num_proc=@num_proc and ps.item=@item and nota_fiscal=@num_nf

GO
