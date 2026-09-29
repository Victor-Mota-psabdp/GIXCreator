SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create Procedure [dbo].[spVerificaInfosIMP06_Sel] --'IMFMC201108092BR','3339'

	@NUM_PROC	VARCHAR(16),
	@NF			VARCHAR(10)

as

	select
		PS.Item,
		cProd Material,
		(select top 1 cd_planta from Atlantis.dbo.pessoa_llp where cd_pes=P.Cd_Buyer) Centro_Custo,
		sum(NFD.qCom) * Atlantis.dbo.fBuscaPorcentagem_CdPedido(@Num_Proc,PS.Item,PS.Cd_Pedido) Qtd,
		sum(NFD.vProd) * Atlantis.dbo.fBuscaPorcentagem_CdPedido(@Num_Proc,PS.Item,PS.Cd_Pedido) Vlr_Item, --o nome do campo na tab está errado "peso_liquido" o correto seria Vlr_Item
		NFD.NCM,
		'IC0' DirFiscalICMS,
		'IP0' DirFiscalIPI,
		'ZC0' LeiCofins,
		'ZP0' LeiPais,
		NFD.CFOP,
		sum(NFT.vOutros)  * Atlantis.dbo.fBuscaPorcentagem_CdPedido(@Num_Proc,PS.Item,PS.Cd_Pedido) Valor,
		'1' + NFI.CST,
		(select top 1 Cd_Vendor from Atlantis.dbo.Pessoa_LLP where cd_pes = P.cd_seller ) ID_Fornecedor
	from
		ATL_BR.dbo.Danfe_Base NF
		Join ATL_BR.dbo.Danfe_Item_Produto NFD ON NFD.ID_Danfe=NF.ID_Danfe
		Join Produto_Cliente PC on right(PC.cd_proc_Cliente,8) COLLATE Latin1_General_CI_AI = right(NFD.cProd,8) and cd_Cliente = '362'
		Join Pedido_Ship PS on PS.Cd_Produto=PC.Cd_Prod and PS.Num_Proc=@NUM_PROC
		Join Pedido P on P.Cd_Pedido=PS.Cd_Pedido
		Join ATL_BR.dbo.Danfe_Totais NFT ON NFT.ID_Danfe=NF.ID_Danfe
		Join ATL_BR.dbo.Danfe_Item_Impostos NFI ON NFI.ID_Danfe=NF.ID_Danfe and NFI.ID_Item = NFD.ID_Item and NFI.cImpostos='ICMS'
	where
		NF.Num_Proc like @NUM_PROC and 
		NF.dtEnvio is null 
		and 
		nNF=@NF
	group by
		PS.Item,cProd,NFD.NCM,NFD.CFOP,NFI.CST,P.Cd_Buyer,PS.Cd_Pedido,P.cd_seller
























GO
