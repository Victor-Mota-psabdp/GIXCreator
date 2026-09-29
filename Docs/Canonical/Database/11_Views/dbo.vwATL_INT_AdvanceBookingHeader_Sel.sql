SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwATL_INT_AdvanceBookingHeader_Sel]
AS

select
	Header.ID_ABH						[ID],
	PurchaseOrderNumber.Value+'PB'		[Number],	
	
	Header.Message						[Message],
	Header.Cd_Pedido					[Order Created ID],
			
	TP.cd_Tp_Pedido						[Type Code],
	TP.Nome_Tp_Pedido					[Type Name],	
			
	Incoterms.Id						[Incoterm Code],
	Incoterm.Nome_Tp_Oper				[Incoterm Name],	
		
	Currency.Cd_Tp_Moeda				[Currency Code],
	Currency.Nome_Tp_Moeda				[Currency Name],
			
	TSP.Cd_Tp_Status_Pedido				[Status Code],
	TSP.Nome_Tp_Status_Pedido			[Status Name],
			
	Shipper.Id							[Seller Code],
	Shipper.Id							[Seller Name],

			
	ShipFrom.Id							[Shipper Code],
	ShipFrom.Id							[Shipper Name],	
			
	Consignee.Id						[Buyer Code],
	Consignee.Id						[Buyer Name],
	Consignee.Name						[Buyer Complete Name],
	Consignee.Address					[Buyer Address],
	Consignee.City						[Buyer City],
	Consignee.PostalCode				[Buyer PostalCode],
	Consignee.Country					[Buyer Country],
	Consignee.ID						[Buyer ID],
			
	Shipto.Id							[Consignee Code],
	Shipto.Id							[Consignee Name],
	Shipto.Name							[Consignee Complete Name],
	Shipto.Address						[Consignee Address],
	Shipto.City							[Consignee City],
	Shipto.PostalCode					[Consignee PostalCode],
	Shipto.Country						[Consignee Country],
	Shipto.ID							[Consignee ID],
			
	GR.Cd_Pes							[Group Code],
	GR.Apelido							[Group Name],
			
	OriginCountry.isoCountryCode		[Origin Code],
	Origin.Nome_Pais					[Origin Name],		
			
	DestinationCountry.isoCountryCode	[Destination Code],
	Destin.Nome_Pais					[Destination Name],		
			
	PurchaseOrderNumber.Value			[PO],
	PurchaseOrderNumber.Value			[Customer PO],			
	
	GoodsAvailableShipDate.Value		[Order Date],
	GoodsAvailableShipDate.Value		[PO Req. Deliv.],
	NULL								[Selling SAP],
	Body.OriginPlantCode				[Plant ID],
	NULL								[Contact],
			
	NULL								[CSR Name Code],
	Body.CSRName						[CSR Name],

	NULL								[USER ID Code],
	NULL								[USER ID Name],
			
	NULL								[Responsible PO Code],
	NULL								[Responsible PO Name],	
			
	TM.Id								[Modal Code],
	TM.Modal							[Modal Name],		

	Header.SystemCode                   [SystemCode]
from ATL_INT.[dbo].[AdvanceBookingHeader] Header
	Left join ATL_INT.[dbo].[AdvanceBookingBody] Body on Body.ID_ABH = Header.ID_ABH
	Left join ATL_INT.[dbo].[AdvanceBookingBodyReference] PurchaseOrderNumber on PurchaseOrderNumber.ID_ABH = Body.ID_ABH and PurchaseOrderNumber.Name = 'PurchaseOrderNumber'

	Left join ATL_INT.[dbo].[AdvanceBookingBodyIncoterms] Incoterms on Incoterms.ID_ABH = Body.ID_ABH
	Left join ATL_INT.[dbo].[AdvanceBookingBodyAddress] ShipFrom on ShipFrom.ID_ABH = Body.ID_ABH and ShipFrom.Type = 'ShipFrom'
	Left join ATL_INT.[dbo].[AdvanceBookingBodyAddress] Shipper on Shipper.ID_ABH = Body.ID_ABH and Shipper.Type = 'Shipper'	
	Left join ATL_INT.[dbo].[AdvanceBookingBodyAddress] Consignee on Consignee.ID_ABH = Body.ID_ABH and Consignee.Type = 'Consignee'
	Left join ATL_INT.[dbo].[AdvanceBookingBodyAddress] ShipTo on ShipTo.ID_ABH = Body.ID_ABH and ShipTo.Type = 'ShipTo'
	Left join ATL_INT.[dbo].[AdvanceBookingBodyOriginCountry] OriginCountry on OriginCountry.ID_ABH = Body.ID_ABH
	Left join ATL_INT.[dbo].[AdvanceBookingBodyDestinationCountry] DestinationCountry on DestinationCountry.ID_ABH = Body.ID_ABH
	Left join ATL_INT.[dbo].[AdvanceBookingBodyDate] GoodsAvailableShipDate on GoodsAvailableShipDate.ID_ABH = Body.ID_ABH and GoodsAvailableShipDate.Type = 'GoodsAvailableShipDate'

	join Atlantis.dbo.Tipo_Pedido TP on TP.cd_Tp_Pedido = '5'
	join Atlantis.dbo.Tipo_Modal TM on TM.Id = 'O'
	join Atlantis.dbo.Tipo_Moeda Currency on Currency.Cd_Tp_Moeda = 'USD'
	join Atlantis.dbo.Tipo_Status_Pedido TSP on TSP.Cd_Tp_Status_Pedido = 'O'
	join Atlantis.dbo.Pessoa GR on GR.Cd_Pes = '1'
	left join Atlantis.dbo.Tipo_Oper Incoterm on Incoterm.Cd_Tp_Oper = Incoterms.Id
	left join Pais Origin on Origin.cd_pais = OriginCountry.isoCountryCode
	left join Pais Destin on Destin.cd_pais = DestinationCountry.isoCountryCode	


	
--from ATL_INT.dbo.[AdvanceBookingHeader] Header
--	Left join ATL_INT.dbo.[AdvanceBookingBody] Body on Body.ID_ABH = Header.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyProductDetail] ProductDetail on ProductDetail.ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyProductDetailGrossWeight] GrossWeight on GrossWeight.ID_ABH = ProductDetail.ID_ABH and GrossWeight.ID_ABBPDT = ProductDetail.ID_ABBPDT
--	Left join ATL_INT.dbo.[AdvanceBookingBodyProductDetailNetWeight] NetWeight on NetWeight.ID_ABH = ProductDetail.ID_ABH and NetWeight.ID_ABBPDT = ProductDetail.ID_ABBPDT
--	Left join ATL_INT.dbo.[AdvanceBookingBodyReference] PurchaseOrderNumber on PurchaseOrderNumber.ID_ABH = Body.ID_ABH and PurchaseOrderNumber.Name = 'PurchaseOrderNumber'
--	Left join ATL_INT.dbo.[AdvanceBookingBodyIncoterms] Incoterms on Incoterms.ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyAddress] ShipFrom on ShipFrom.ID_ABH = Body.ID_ABH and ShipFrom.Type = 'ShipFrom'
--	Left join ATL_INT.dbo.[AdvanceBookingBodyAddress] Shipper on Shipper.ID_ABH = Body.ID_ABH and Shipper.Type = 'Shipper'	
--	Left join ATL_INT.dbo.[AdvanceBookingBodyAddress] Consignee on Consignee.ID_ABH = Body.ID_ABH and Consignee.Type = 'Consignee'
--	Left join ATL_INT.dbo.[AdvanceBookingBodyOriginCountry] OriginCountry on OriginCountry.ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyDestinationCountry] DestinationCountry on DestinationCountry.ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyDate] GoodsAvailableShipDate on GoodsAvailableShipDate.ID_ABH = Body.ID_ABH and GoodsAvailableShipDate.Type = 'GoodsAvailableShipDate'

--	Left join ATL_INT.dbo.[AdvanceBookingBodyIncotermsLocation] IncotermsLocation on IncotermsLocation.ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyPlaceOfReceipt] PlaceOfReceipt on PlaceOfReceipt.ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyPortOfLoading] PortOfLoading on PortOfLoading.ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyPortOfDischarge] PortOfDischarge on PortOfDischarge.ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyPlaceOfDelivery] PlaceOfDelivery on PlaceOfDelivery.ID_ABH = Body.ID_ABH	
--	Left join ATL_INT.dbo.[AdvanceBookingBodyReference] Reference on Reference.ID_ABH = Body.ID_ABH 
--	Left join ATL_INT.dbo.[AdvanceBookingBodyDate] [Date] on [Date].ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyCarrier] Carrier on Carrier.ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyCarrierFreightContractInfo] CarrierFreightContractInfo on CarrierFreightContractInfo.ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyAddress] [Address] on [Address].ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyProductDetail] ProductDetail on ProductDetail.ID_ABH = Body.ID_ABH
--	Left join ATL_INT.dbo.[AdvanceBookingBodyProductDetailExtraNumberOfPackages] ExtraNumberOfPackages on ExtraNumberOfPackages.ID_ABH = ProductDetail.ID_ABH  and  ExtraNumberOfPackages.ID_ABBPDT = ProductDetail.ID_ABBPDT
--	Left join ATL_INT.dbo.[AdvanceBookingBodyProductDetailGrossWeight] GrossWeight on GrossWeight.ID_ABH = ProductDetail.ID_ABH  and  GrossWeight.ID_ABBPDT = ProductDetail.ID_ABBPDT
--	Left join ATL_INT.dbo.[AdvanceBookingBodyProductDetailGrossVolume] GrossVolume on GrossVolume.ID_ABH = ProductDetail.ID_ABH  and  GrossVolume.ID_ABBPDT = ProductDetail.ID_ABBPDT
--	Left join ATL_INT.dbo.[AdvanceBookingBodyProductDetailNetWeight] NetWeight on NetWeight.ID_ABH = ProductDetail.ID_ABH  and  NetWeight.ID_ABBPDT = ProductDetail.ID_ABBPDT
--	Left join ATL_INT.dbo.[AdvanceBookingBodyProductDetailHazardousDetail] HazardousDetail on HazardousDetail.ID_ABH = ProductDetail.ID_ABH  and  HazardousDetail.ID_ABBPDT = ProductDetail.ID_ABBPDT
--	Left join ATL_INT.dbo.[AdvanceBookingBodyProductDetailMinTemperature] MinTemperature on MinTemperature.ID_ABH = ProductDetail.ID_ABH  and  MinTemperature.ID_ABBPDT = ProductDetail.ID_ABBPDT
--	Left join ATL_INT.dbo.[AdvanceBookingBodyProductDetailMaxTemperature] MaxTemperature on MaxTemperature.ID_ABH = ProductDetail.ID_ABH  and  MaxTemperature.ID_ABBPDT = ProductDetail.ID_ABBPDT




GO
