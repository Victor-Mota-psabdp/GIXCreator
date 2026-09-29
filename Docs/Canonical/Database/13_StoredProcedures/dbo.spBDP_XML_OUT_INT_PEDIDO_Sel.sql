SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spBDP_XML_OUT_INT_PEDIDO_Sel] 'EMSLA201901003BR'
CREATE PROCEDURE [dbo].[spBDP_XML_OUT_INT_PEDIDO_Sel] 
(
	@num_proc	varchar(16)
)
as

select  
	PC.cd_proc_cliente GMID,
	replace(ltrim(rtrim(Produto_descr )),char(160),'') BrandName,
	replace(ltrim(rtrim(CHB.Descricao_Longa )),char(160),'') InvoiceDesc,
	Isnull(LEFT(PD.NCM,6),'')+'00' ClassificationNumber,
	PD.Peso_Liquido_TOT NetWtKgs,
	PD.Peso_UOM,
	PDC.Vlr_FOB DeclaredValue,
	PD.Vlr_Total_Item AMT,
	
	PED.cd_tp_moeda ProductAmountCurrency,
	
	--189 - Job - Additional Fields.Comissao Agente Desp. Exp
	[dbo].[fBusca_CampoCliente](PS.Num_Proc,189) OtherFeeAmount
	--Peso_Uom, Isnull(LEFT(NCM,6),'')+'00' NCM_CODE,cd_dst,Descr_org,UOM,cd_tp_moeda,
	--replace(ltrim(rtrim(Produto_descr )),char(160),'') BrandName,
	--PS.Qty QUANTIDADE,NCM,Natop,UOM Tipo_Unid,UOM_PRC, 
	--Case 
	--	When Vlr_Item > 10000 then Vlr_Item/100000
	--	else Vlr_Item
	--End
		
	--preco_unit
	--,PED.cd_tp_moeda,peso_item Peso_bruto,peso_invoice,peso_bruto_tot,peso_bruto_tot,
	--ps.lote,Isnull(Descricao_Termo,'60 Days of Invoice Date') Termo,
	--Isnull(TP.Cd_Termo,'281') cd_Termo,'PedidoD' 
from Pedido_Ship PS With(Nolock)
Join Produto_Cliente PC With(Nolock) on PC.cd_prod=PS.cd_produto
left join Produto_CHB CHB With(Nolock) on PS.cd_produto = CHB.cd_prod
Join Pedido_DET PD With(Nolock) on PS.cd_produto=PD.cd_produto and PS.cd_pedido=PD.cd_pedido
Join Pedido  PED With(Nolock) on PED.cd_pedido=PS.cd_pedido
LEFT Join Pedido_Det_Complementar PDC With(Nolock) on PS.cd_produto=PDC.cd_produto and PS.cd_pedido=PDC.cd_pedido
--Left Join De_Para TIPO With(Nolock) on TIPO.cd_org=UOM and Tipo.cd_tipo=3
--left Join  TErmo_PAgamento TP With(Nolock) on cast(TP.cd_termo as varchar(30))=payment
WHERE
	NUM_PROC=@NUM_PROC 
	and cd_proc_cliente is not null
--group by

--UOM,cd_tp_moeda,cd_proc_cliente ,Produto_descr ,PS.Qty ,NCM,Natop,UOM ,UOM_PRC,Vlr_Item ,PED.cd_tp_moeda,peso_item,
--cd_dst,Descr_org,UOM,cd_tp_moeda,peso_invoice,peso_liquido_tot,peso_bruto_tot,LEFT(NCM,6),PS.lote ,
--Peso_Uom,Descricao_Termo,TP.cd_Termo

	
GO
