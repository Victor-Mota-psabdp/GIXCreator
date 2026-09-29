SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spPedidoDet_Perigoso_Rel] --'44716'

	@Cd_Pedido int
as
	SELECT 
		CD_PROC_CLIENTE,
		Produto_Descr,
		PD.Lote Lote,
		PD.Item Item,
		PDP.HAZMAT_CD,
		HAZMAT_CLASS_CD,
		HAZMAT_DESC,
		HAZMAT_CONTACT,
		HAZMAT_PAGE,
		HAZMAT_FPOINT,
		HAZMAT_FPOINT_CD,
		HAZMAT_PULL_DESC_FRM_BDP,
		HAZMAT_ORG_DESC,
		HAZMAT_DESC_QUAL
	FROM 
		Pedido_Det_Perigoso PDP with(nolock)
		join PEDIDO_DET PD with(nolock) on PDP.cd_pedido = PD.Cd_Pedido and PDP.cd_produto = PD.Cd_Produto and PDP.ITEM = PD.Item and PDP.Lote = PD.Lote
		join Pedido P with(nolock) on PD.Cd_Pedido = P.Cd_Pedido 
		left Join Produto_Cliente PC with(nolock) on PC.CD_PROD=PD.CD_PRODUTO and P.Cd_Grupo = Cd_Cliente
	where
		P.cd_pedido=@cd_pedido
	order by 
		Item, CD_PROC_CLIENTE









GO
