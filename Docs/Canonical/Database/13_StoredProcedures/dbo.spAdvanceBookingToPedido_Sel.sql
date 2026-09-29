SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from ATL_INT.[dbo].[AdvanceBookingHeader] where Cd_Pedido is not null
--update ATL_INT.[dbo].[AdvanceBookingHeader] set Dt_Ins_Pedido = null, message = null, Cd_Pedido = null where Cd_Pedido is not null

--[spAdvanceBookingToPedido_Sel]'13'
CREATE procedure [dbo].[spAdvanceBookingToPedido_Sel] --'13'
(
	@SystemCode bigint   
)

as 

select
	Header.ID_ABH						[ID],
	(Case when PurchaseOrderNumber.Value = null then 
		PurchaseOrderNumber.Value + 'PB'
	else 
		OrderNumberLink.Value +'PB' end) [Number],
	--PurchaseOrderNumber.Value+'PB'		[Number],
	--OrderNumberLink.Value +'PB'			[Number],
	NULL								[Order Value],
			
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
			
	isnull(PurchaseOrderNumber.Value,OrderNumberLink.Value)			[PO],
	isnull(PurchaseOrderNumber.Value,OrderNumberLink.Value)				[Customer PO],			
	
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

	Header.SystemCode                   [SystemCode],
	Body.Action							[Action]
from ATL_INT.[dbo].[AdvanceBookingHeader] Header
	Left join ATL_INT.[dbo].[AdvanceBookingBody] Body on Body.ID_ABH = Header.ID_ABH
	Left join ATL_INT.[dbo].[AdvanceBookingBodyReference] PurchaseOrderNumber on PurchaseOrderNumber.ID_ABH = Body.ID_ABH and PurchaseOrderNumber.Name = 'PurchaseOrderNumber'
	Left join ATL_INT.[dbo].[AdvanceBookingBodyReference] OrderNumberLink on OrderNumberLink.ID_ABH = Body.ID_ABH and OrderNumberLink.Name = 'OrderNumberLink'

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
Where
	Header.SystemCode = '13'
	And Header.Dt_Ins_Pedido is null
Order by 1


GO
