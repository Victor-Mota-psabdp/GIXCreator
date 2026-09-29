SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGIX_XMLToNota_Cliente_Det_Sel]--40
(	
	@ID_Req as BigInt
)

as
	
Select
	P.Apelido										[Cliente],
	OrderNumber.Ref_Number							[Pedido],
	ProductDetail.ProductCode						[Produto],
	(Case when SUBSTRING(ImportForwarderRefNbr.Ref_Number,2,1) = 'M' then '2' else
		(Case when SUBSTRING(ImportForwarderRefNbr.Ref_Number,2,1) = 'O' then '1' else
			(Case when SUBSTRING(ImportForwarderRefNbr.Ref_Number,2,1) = 'A' then '3'
	end)end)end)									[Modal],
	TariffClassification.ProductCodesNamesCode		[NCM],
	
	
	sum(convert(float,ProductDetail.BilledQuantity))		[Quantidade],
	sum(convert(float,ProductDetail.Price))							[Vlr_Item],
	sum(convert(float,ProductDetail.BilledQuantity) * convert(float,ProductDetail.Price)) [Vlr_Total_Item],
	
	
	sum(convert(float,OtherFeeAmountFRETE.AmountValue)	/ convert(float,Notes.Notes)) vlr_frete,
	sum(convert(float,OtherFeeAmountSEGURO.AmountValue) / convert(float,Notes.Notes)) Vlr_Seguro,
	
	0												Vlr_Outras_Despesas,
	
	DII.RoleInd										[ALIQ_II],
	sum(convert(float,DII.Amount))					[VLr_II],
	
	DIPI.RoleInd									[ALIQ_IPI],
	sum(convert(float,DIPI.Rate))										[VLr_BASE_IPI],	
	sum(convert(float,DIPI.Rate))										[VLr_TRIBUTAVEL_IPI],
	sum(convert(float,DIPI.Amount))										[VLr_IPI], 
	
	PIS.RoleInd										[VLr_ALIQ_PIS],
	sum(convert(float,PIS.Rate))										[VLr_BASE_PIS],
	sum(convert(float,PIS.Amount))										[VLr_IMPOSTO_PIS],
	
	Cofins.RoleInd									[VLr_ALIQ_COFINS],
	sum(convert(float,Cofins.Rate))										[VLr_BASE_COFINS],
	sum(convert(float,Cofins.Amount))									[VLr_IMPOSTO_COFINS],
	
	ICMS.RoleInd									[ALIQ_ICMS],
	sum(convert(float,ICMS.Rate))										[VLr_BASE_ICMS],	
	sum(convert(float,ICMS.Amount))										[VLr_ICMS],
	sum(convert(float,ICMS.Rate	))										[VLr_TRIBUTAVEL_ICMS],
	
	sum(convert(float,DIPI.Rate	))									[Vlr_Total_NF],
	sum(convert(float,PESOLIQUIDO.Amount))								[Peso_Liquido],
	sum(convert(float,PESOBRUTO.Amount))								[Peso_Bruto],
	
	100												[SITT],
	sum(convert(float,OtherFeeAmountSISCOMEX.AmountValue) / convert(float,Notes.Notes))	[Vlr_Siscomex],
	sum(convert(float,DII.Rate))										[VL_BASE_II],
	ImportForwarderRefNbr.Ref_Number				[Num_Proc],
	--DII.ID_ProductFees								[id_Item],
	--ProductDetail.LineItemNo						[id_Item],
	0												[id_Item],
	null											[ACRESCIMOS],
	sum(convert(float,DII.Rate))										[CIF],
	null											[FOB],
	0												[FreteCollect],	
	sum(convert(float,AFRMM.AmountValue)	/ convert(float,Notes.Notes))	[AFRMM]
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwClienteALLJOBS V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	
	join ATL_INT.dbo.GIX_Detail_ProductDetail ProductDetail on ProductDetail.ID_Req = Request.ID_Req	
	--join ATL_QA_1006.dbo.Produto_Cliente PC on PC.cd_Proc_Cliente = ProductDetail.ProductCode	

	
	join ATL_INT.dbo.GIX_Detail_ProductReferences FactoryCode on FactoryCode.ID_Req = ProductDetail.ID_Req 
		and FactoryCode.ID_Detail = ProductDetail.ID_Detail and FactoryCode.ProductReferences_Type = 'FactoryCode'
		
	join Pessoa P with (nolock) on V.cd_cliente = P.Cd_Pes
				
	--join ATL_INT.dbo.GIX_Header_References OrderNumber on OrderNumber.ID_Req = Request.ID_Req 
	--	and OrderNumber.Ref_Type = 'OrderNumber'
	join (select distinct ID_Req, Ref_Number from ATL_INT.dbo.GIX_Header_References where Ref_Type = 'OrderNumber')
	 as OrderNumber on OrderNumber.ID_Req = Request.ID_Req 

	join ATL_INT.dbo.GIX_Detail_ProductCodesNames TariffClassification on TariffClassification.ID_Req = ProductDetail.ID_Req 
		and TariffClassification.ID_Detail = ProductDetail.ID_Detail and TariffClassification.Id_ProductcodesNames = ID_ProductDetail
		and TariffClassification.ProductCodesNamesType = 'TariffClassification'


	join ATL_INT.dbo.GIX_Detail_ProductFees DII on DII.ID_Req = ProductDetail.ID_Req 
		and DII.ID_Detail = ProductDetail.ID_Detail and DII.Code = 'II'
		
	join ATL_INT.dbo.GIX_Detail_ProductFees DIPI on DIPI.ID_Req = ProductDetail.ID_Req 
		and DIPI.ID_Detail = ProductDetail.ID_Detail and DIPI.Code = 'IPI'
		
	join ATL_INT.dbo.GIX_Detail_ProductFees PIS on PIS.ID_Req = ProductDetail.ID_Req 
		and PIS.ID_Detail = ProductDetail.ID_Detail and PIS.Code = 'PIS'
		
	join ATL_INT.dbo.GIX_Detail_ProductFees COFINS on COFINS.ID_Req = ProductDetail.ID_Req 
		and COFINS.ID_Detail = ProductDetail.ID_Detail and COFINS.Code = 'COFINS'
		
	join ATL_INT.dbo.GIX_Detail_ProductFees ICMS on ICMS.ID_Req = ProductDetail.ID_Req 
		and ICMS.ID_Detail = ProductDetail.ID_Detail and ICMS.Code = 'ICMS'

	join ATL_INT.dbo.GIX_Detail_ProductFees PESOLIQUIDO on PESOLIQUIDO.ID_Req = ProductDetail.ID_Req 
		and PESOLIQUIDO.ID_Detail = ProductDetail.ID_Detail and PESOLIQUIDO.Code = 'PESOLIQUIDO'
		
	join ATL_INT.dbo.GIX_Detail_ProductFees PESOBRUTO on PESOBRUTO.ID_Req = ProductDetail.ID_Req 
		and PESOBRUTO.ID_Detail = ProductDetail.ID_Detail and PESOBRUTO.Code = 'PESOBRUTO'
	
	join ATL_INT.dbo.GIX_Header_Notes Notes on Notes.ID_Req = Request.ID_Req and Notes.Note_Type = 'EDI'
	
	join ATL_INT.dbo.GIX_Header_Amount OtherFeeAmountFRETE on OtherFeeAmountFRETE.ID_Req = Request.ID_Req 
		and OtherFeeAmountFRETE.AmountType  = 'OtherTaxAmount' and OtherFeeAmountFRETE.AmountCode = 'FRETE'
	
	join ATL_INT.dbo.GIX_Header_Amount OtherFeeAmountSEGURO on OtherFeeAmountSEGURO.ID_Req = Request.ID_Req 
		and OtherFeeAmountSEGURO.AmountType  = 'OtherTaxAmount' and OtherFeeAmountSEGURO.AmountCode = 'SEGURO'
	
	join ATL_INT.dbo.GIX_Header_Amount OtherFeeAmountSISCOMEX on OtherFeeAmountSISCOMEX.ID_Req = Request.ID_Req 
		and OtherFeeAmountSISCOMEX.AmountType  = 'OtherTaxAmount' and OtherFeeAmountSISCOMEX.AmountCode = 'SISCOMEX'
	
	join ATL_INT.dbo.GIX_Header_Amount AFRMM on AFRMM.ID_Req = Request.ID_Req 
		--and AFRMM.AmountType = 'ChargeableWeight' 
		and AFRMM.AmountCode = 'AFRMM'
		
	left join Pedido D on D.Num_Pedido = OrderNumber.Ref_Number and D.Cd_Grupo = 'P21128' and Status='C'
	
	
Where
	Request.ID_Req = @ID_Req
	and SystemCode = '1'
	and D.Cd_pedido is not null
	and D.Dt_Pedido > GETDATE() -720
Group by
	--ProductDetail.ProductCode,
	--P.Apelido,
	--OrderNumber.Ref_Number,	
	--ImportForwarderRefNbr.Ref_Number,
	--TariffClassification.ProductCodesNamesCode,	
	--DII.RoleInd,
	--DIPI.RoleInd,
	--PIS.RoleInd,
	--Cofins.RoleInd,
	--ICMS.RoleInd,
	--DII.ID_ProductFees
	
	ProductDetail.ProductCode,
	P.Apelido,
	OrderNumber.Ref_Number,
	(Case when SUBSTRING(ImportForwarderRefNbr.Ref_Number,2,1) = 'M' then '2' else
		(Case when SUBSTRING(ImportForwarderRefNbr.Ref_Number,2,1) = 'O' then '1' else
			(Case when SUBSTRING(ImportForwarderRefNbr.Ref_Number,2,1) = 'A' then '3'
	end)end)end),	
	ImportForwarderRefNbr.Ref_Number,
	TariffClassification.ProductCodesNamesCode,
	DII.RoleInd,
	DIPI.RoleInd,
	PIS.RoleInd,
	Cofins.RoleInd,
	ICMS.RoleInd,
	DII.ID_ProductFees	
GO
