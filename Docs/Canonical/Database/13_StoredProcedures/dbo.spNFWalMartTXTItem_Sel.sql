SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[spNFWalMartTXTItem_Sel] --'11', 'P16966'
(
	@Id_Danfe int
)
as

select
		DItem.ID_Item,
		DIP.cProd Cd_Proc_cliente,
		DIP.xProd Produto_Descr,
		DIP.NCM,
		DIP.qCOM Quantidade,
		DIP.uCom UoM,
		DIP.CFOP CFOP,
		DIP.vUNCom Vlr_Item,
		DIP.vProd Vlr_Total_Item,
		DIP.vFrete Vlr_Frete,
		DIP.vSeguro Vlr_Seguro,
		DIP.vDesconto Vlr_Desconto,
		DICMS.vBC VL_Base_ICMS,
		DICMS.pImposto ALIQ_ICMS,
		DICMS.vImposto VL_ICMS,
		DICMS.cST Cd_ICMS_ST,
		DICMS.orig Cd_orig,
		DICMS.modBC Cd_modBD,
		DIPI.vBC VL_BASE_IPI,
		DIPI.pImposto ALIQ_IPI,
		DIPI.vImposto VL_IMPOSTO_IPI,
		DIPI.cST Cd_IPI_ST,
		DIPI.cSelo Cd_Selo_Ctrl_IPI,
		DIPI.qSelo Q_Selo_Ctrl_IPI,
		DIPI.cEnq Cd_Enq,
		DPIS.vBC VL_BASE_PIS,
		DPIS.pImposto VL_ALIQ_PIS,
		DPIS.vImposto VL_IMPOSTO_PIS,
		DPIS.cST Cd_PIS_ST,
		DCOFINS.vBC VL_Base_Cofins,
		DCOFINS.pImposto VL_ALIQ_Cofins,
		DCOFINS.vImposto VL_IMPOSTO_Cofins,
		DCOFINS.cST Cd_COFINS_ST,
		isnull(DIP.cEAN,'') UPC

from
		Danfe_Item DItem
	join danfe_Item_Produto DIP on DItem.Id_Danfe = DIP.Id_Danfe and DItem.Id_Item = DIP.Id_Item
	left outer join Danfe_Item_Impostos DCOFINS on DItem.Id_Danfe = DCOFINS.Id_Danfe and DItem.Id_Item = DCOFINS.Id_Item and DCOFINS.cImpostos = 'COFINS'
	left outer join Danfe_Item_Impostos DICMS on DItem.Id_Danfe = DICMS.Id_Danfe and DItem.Id_Item = DICMS.Id_Item and DICMS.cImpostos = 'ICMS'
	left outer join Danfe_Item_Impostos DII on DItem.Id_Danfe = DII.Id_Danfe and DItem.Id_Item = DII.Id_Item and DII.cImpostos = 'II'
	left outer join Danfe_Item_Impostos DIPI on DItem.Id_Danfe = DIPI.Id_Danfe and DItem.Id_Item = DIPI.Id_Item and DIPI.cImpostos = 'IPI'
	left outer join Danfe_Item_Impostos DPIS on DItem.Id_Danfe = DPIS.Id_Danfe and DItem.Id_Item = DPIS.Id_Item and DPIS.cImpostos = 'PIS'
	where DItem.Id_Danfe = @Id_Danfe 


--join pessoa_llp PLLP on PLLP.Cd_pes = @Cd_Cliente
--left outer join pedido_det PDD on NCD.Cd_Pedido = PDD.Cd_Pedido and NCD.Cd_Produto = PDD.Cd_Produto
--join produto_cliente PC on NCD.Cd_Produto = PC.Cd_Prod 
--where PLLP.cd_pes_grupo = 'P16851' and NCD.Cd_Cliente = @Cd_Cliente and NCD.ID_NF = @ID_NF









GO
