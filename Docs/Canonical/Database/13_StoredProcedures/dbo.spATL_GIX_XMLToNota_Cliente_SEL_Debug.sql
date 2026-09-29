SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_GIX_XMLToNota_Cliente_SEL_Debug] '1','ImportForwarderRefNbr'
--[spATL_GIX_XMLToNota_Cliente_SEL] '4','BDPJobNumber'
CREATE procedure [dbo].[spATL_GIX_XMLToNota_Cliente_SEL_Debug]
(
	@SystemCode VARCHAR(25),
	@Ref_Type VARCHAR(100)
	
)

as
	
Select distinct
	ImportForwarderRefNbr.Ref_Number				[Num_Proc],	
	DeliveryNote.ProductReferenceNumber				[nNF],
	GenericReferenceNumber.ProductReferenceNumber	[Serie],
	FactoryCode.ProductReferenceNumber				[CNPJ],
	AddlDescr1.ProductReferenceNumber				[AddlDescr1],
	AddlDescr2.ProductReferenceNumber				[AddlDescr2],
	AddlDescr3.ProductReferenceNumber				[CFOP],	
	--ProductDates.ProductDatesDate					[dEmis],
	RIGHT(ProductDates.ProductDatesDate,4)+'-'
		+ left(ProductDates.ProductDatesDate,2) + '-'
		+ substring(ProductDates.ProductDatesDate,3,2) [dEmis],
	0												[vNF],
	P.Apelido										Cliente,
	'N'												Complementar,	
	Request.ID_Req,
	Request.dt_ins 
	--DC.CNPJ,
	--DB.nNF,
	--DB.dEmis,
	--DIP.CFOP,
	--DT.vNF,
	--P.Apelido Cliente,
	--'N' Complementar,
from ATL_INT.dbo.GIX_Request_Header Request with (nolock)
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with (nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		--and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	Left  join vwClienteALLJOBS V with (nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	Left join ATL_INT.dbo.GIX_Detail_ProductDetail ProductDetail with (nolock) on ProductDetail.ID_Req = Request.ID_Req
			
	Left join ATL_INT.dbo.GIX_Detail_ProductReferences DeliveryNote with (nolock) on DeliveryNote.ID_Req = ProductDetail.ID_Req 
		and DeliveryNote.ID_Detail = ProductDetail.ID_Detail and DeliveryNote.ProductReferences_Type = 'DeliveryNote'
	Left join ATL_INT.dbo.GIX_Detail_ProductReferences GenericReferenceNumber with (nolock) on GenericReferenceNumber.ID_Req = ProductDetail.ID_Req 
		and GenericReferenceNumber.ID_Detail = ProductDetail.ID_Detail and GenericReferenceNumber.ProductReferences_Type = 'GenericReferenceNumber'
	Left join ATL_INT.dbo.GIX_Detail_ProductReferences FactoryCode with (nolock) on FactoryCode.ID_Req = ProductDetail.ID_Req 
		and FactoryCode.ID_Detail = ProductDetail.ID_Detail and FactoryCode.ProductReferences_Type = 'FactoryCode'
	Left join ATL_INT.dbo.GIX_Detail_ProductReferences AddlDescr1 with (nolock) on AddlDescr1.ID_Req = ProductDetail.ID_Req 
		and AddlDescr1.ID_Detail = ProductDetail.ID_Detail and AddlDescr1.ProductReferences_Type = 'AddlDescr1'
	Left join ATL_INT.dbo.GIX_Detail_ProductReferences AddlDescr2 with (nolock) on AddlDescr2.ID_Req = ProductDetail.ID_Req 
		and AddlDescr2.ID_Detail = ProductDetail.ID_Detail and AddlDescr2.ProductReferences_Type = 'AddlDescr2'
	Left join ATL_INT.dbo.GIX_Detail_ProductReferences AddlDescr3 with (nolock) on AddlDescr3.ID_Req = ProductDetail.ID_Req 
		and AddlDescr3.ID_Detail = ProductDetail.ID_Detail and AddlDescr3.ProductReferences_Type = 'AddlDescr3'
		
	Left join ATL_INT.dbo.GIX_Detail_ProductDates ProductDates with (nolock) on ProductDates.ID_Req = ProductDetail.ID_Req 
		and ProductDates.ID_Detail = ProductDetail.ID_Detail 
	
	Left join Pessoa P with (nolock) on V.cd_cliente = P.Cd_Pes
		--and P.Desat_Pes = 'N' and  P.Num_CPF_CNPJ <>''
	LEFT JOIN pessoa_llp llp with (nolock) on llp.Cd_Pes = V.cd_cliente
		
	left join Nota_Cliente NF with (nolock) on NF.Num_Proc = ImportForwarderRefNbr.Ref_Number
		
	Left join (select distinct ID_Req, Ref_Number from ATL_INT.dbo.GIX_Header_References with(nolock) where Ref_Type = 'OrderNumber')
	 as OrderNumber on OrderNumber.ID_Req = Request.ID_Req 
	 
	left join Pedido D with (nolock) on D.Num_Pedido = OrderNumber.Ref_Number and D.Cd_Grupo = llp.Cd_Pes_Grupo
	--= 'P21128'

Where
	Request.ID_Req = '5552118'	and 
	ImportForwarderRefNbr.Ref_Type = @Ref_Type		and 
	SystemCode = @SystemCode 
	and 	 Utilizado is null	 
	 and NF.ID_NF is null	 
	-- and D.Cd_pedido is not null
	and Request.dt_ins > getdate() -5

	
Order by ID_Req





--Select 
--	ImportForwarderRefNbr.Ref_Number				[Num_Proc],	
--	DeliveryNote.ProductReferenceNumber				[nNF],
--	P.Apelido										Cliente
--from ATL_INT.dbo.GIX_Request_Header Request with (nolock)
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with (nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
--	join vwClienteALLJOBS V with (nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	join ATL_INT.dbo.GIX_Detail_ProductDetail ProductDetail with (nolock) on ProductDetail.ID_Req = Request.ID_Req
			
--	join ATL_INT.dbo.GIX_Detail_ProductReferences DeliveryNote with (nolock) on DeliveryNote.ID_Req = ProductDetail.ID_Req 
--		and DeliveryNote.ID_Detail = ProductDetail.ID_Detail and DeliveryNote.ProductReferences_Type = 'DeliveryNote'
	
--	join Pessoa P with (nolock) on V.cd_cliente = P.Cd_Pes
		
--	left join Nota_Cliente NF with (nolock) on NF.Num_Proc = ImportForwarderRefNbr.Ref_Number
	
--	join ATL_INT.dbo.GIX_Header_References OrderNumber with (nolock) on OrderNumber.ID_Req = Request.ID_Req 
--		and OrderNumber.Ref_Type = 'OrderNumber'
--	left join Pedido D with (nolock) on D.Num_Pedido = OrderNumber.Ref_Number and D.Cd_Grupo = 'P21128'

--Where
--	ImportForwarderRefNbr.Ref_Number = 'IMOXT201802063BR'	
--	and SystemCode = '1'
--	and D.Cd_pedido is not null


--Select 	
--	ImportForwarderRefNbr.Ref_Number			[JOB],	
--	DeliveryNote.ProductReferenceNumber				[nNF],
--	Request.ID_Req
--from ATL_INT.dbo.GIX_Request_Header Request
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
--	left join ATL_INT.dbo.GIX_Detail_ProductDetail ProductDetail with (nolock) on ProductDetail.ID_Req = Request.ID_Req
--	left join ATL_INT.dbo.GIX_Detail_ProductReferences DeliveryNote with (nolock) on DeliveryNote.ID_Req = ProductDetail.ID_Req 
--		and DeliveryNote.ID_Detail = ProductDetail.ID_Detail and DeliveryNote.ProductReferences_Type = 'DeliveryNote'
--where 
--	ImportForwarderRefNbr.Ref_Number ='IMOXT201802063BR'	
	
--select * from Pedido_Ship where Num_Proc = 'IAOXT201802001BR'
--select * from Produto_Cliente where cd_prod = '45420'


GO
