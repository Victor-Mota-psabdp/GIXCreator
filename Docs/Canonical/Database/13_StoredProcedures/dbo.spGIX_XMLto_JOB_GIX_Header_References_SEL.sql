SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spGIX_XMLto_JOB_GIX_Header_References_SEL]--41
	@ID_Req as BigInt
as

Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	EntryNumber.Ref_Number						[Numero_PO],
	(case when (DTREGISTRO.StatusDate = '' OR DTREGISTRO.StatusDate IS NULL) then ''
	else  
	RIGHT(DTREGISTRO.StatusDate,4)+'-'
		+ left(DTREGISTRO.StatusDate,2) + '-'
		+ substring(DTREGISTRO.StatusDate,3,2) end)	[DATA],
	'5'												[ID_DC],
	'005 - DI Number'								[Nome_DC],
	'ATL System'									[Usuario],
			
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO on PO.Num_Proc = V.Num_Proc and PO.ID_DC =5
	join ATL_INT.dbo.GIX_Header_References EntryNumber on EntryNumber.ID_Req = Request.ID_Req 
		and EntryNumber.Ref_Type = 'EntryNumber'
	join ATL_INT.dbo.GIX_Header_Status DTREGISTRO on DTREGISTRO.ID_Req = Request.ID_Req and DTREGISTRO.StatusDescription = 'DTREGISTRO'	
Where
	Request.ID_Req = @ID_Req
	and EntryNumber.Ref_Number is not null
	and SystemCode = '1'
	and PO.Numero_PO is null
	
UNION ALL

Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],	
	Licence.LicenceNumber						[Numero_PO],
	''											[DATA],
	'23'										[ID_DC],
	'023 - LI Number'							[Nome_DC],
	'ATL System'									[Usuario],
	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO on PO.Num_Proc = V.Num_Proc and PO.ID_DC =23
	join ATL_INT.dbo.GIX_Header_License Licence on Licence.ID_Req = Request.ID_Req	
Where
	Request.ID_Req = @ID_Req
	and Licence.LicenceNumber is not null
	and SystemCode = '1'
	and PO.Numero_PO is null
	
	
UNION ALL

Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	Invoice.Invoice_Number						[Numero_PO],
	(case when (Invoice.CIDate = '' OR Invoice.CIDate IS NULL) then ''
	else  
	RIGHT(Invoice.CIDate,4)+'-'
		+ left(Invoice.CIDate,2) + '-'
		+ substring(Invoice.CIDate,3,2) end)			[DATA],
	'2'											[ID_DC],
	'002 - INVOICE'								[Nome_DC],
	'ATL System'									[Usuario],
			
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 2
	join ATL_INT.dbo.GIX_Header_Commercial_Invoice Invoice on Invoice.ID_Req = Request.ID_Req
Where
	Request.ID_Req = @ID_Req
	and Invoice.Invoice_Number is not null
	and SystemCode = '1'
	and PO.Numero_PO is null
	
UNION ALL

Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	right('0000000000' + DeliveryNote.ProductReferenceNumber,10)			[Numero_PO],
	(case when (ProductDates.ProductDatesDate = '' OR ProductDates.ProductDatesDate IS NULL) then ''
		else
	RIGHT(ProductDates.ProductDatesDate,4)+'-'
		+ left(ProductDates.ProductDatesDate,2) + '-'
		+ substring(ProductDates.ProductDatesDate,3,2) end)	[DATA],
	'10'										[ID_DC],	
	'010 - Nota Fiscal'								[Nome_DC],
	'ATL System'									[Usuario],		
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'ImportForwarderRefNbr'
	join vwClienteALLJOBS V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 10
	join ATL_INT.dbo.GIX_Detail_ProductDetail ProductDetail on ProductDetail.ID_Req = Request.ID_Req
			
	join ATL_INT.dbo.GIX_Detail_ProductReferences DeliveryNote on DeliveryNote.ID_Req = ProductDetail.ID_Req 
		and DeliveryNote.ID_Detail = ProductDetail.ID_Detail and DeliveryNote.ProductReferences_Type = 'DeliveryNote'
	join ATL_INT.dbo.GIX_Detail_ProductDates ProductDates on ProductDates.ID_Req = ProductDetail.ID_Req 
		and ProductDates.ID_Detail = ProductDetail.ID_Detail 
Where
	Request.ID_Req = @ID_Req
	and DeliveryNote.ProductReferenceNumber	is not null
	and SystemCode = '1'
	and PO.Numero_PO is null
GO
