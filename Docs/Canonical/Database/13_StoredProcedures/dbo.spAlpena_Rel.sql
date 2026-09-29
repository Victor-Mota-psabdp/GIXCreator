SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure spAlpena_Rel

AS

/**
	29-05-2009
	Verifica ordens que estão no profile Dow para Transferencia para Grupo Dow-Alpena
**/

select substring(customer_PO,5,2)Cia,pd.cd_pedido  from pedido_det PDD
join produto_cliente PC on Pc.cd_prod=cd_produto
Join Projeto_DowAlpena on cd_produto_cliente=cd_proc_cliente
Join Pedido PD on PD.cd_pedido=PDD.cd_pedido
Left Join Pedido_Ship PS on PD.cd_pedido=PS.cd_pedido
where
	dt_pedido > '05-01-2009'

	and ps.cd_pedido is null


GO
