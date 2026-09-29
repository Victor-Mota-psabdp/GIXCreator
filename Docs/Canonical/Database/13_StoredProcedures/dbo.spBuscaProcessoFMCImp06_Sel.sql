SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PRocedure [dbo].[spBuscaProcessoFMCImp06_Sel]
AS

SELECT nc.num_proc,nota_fiscal,item FROM NOTA_CLIENTE NC with(nolock)
Join Nota_Fiscal_Cliente_Det NDD with(nolock) on NC.id_nf=NDD.id_nf and NC.cd_cliente=NDD.cd_cliente
Join Pedido_Ship PS with(nolock) on PS.num_proc=nc.num_proc and ps.cd_produto=NDD.cd_produto
Where envio is null and nc.num_proc like 'I%FMC%'

GO
