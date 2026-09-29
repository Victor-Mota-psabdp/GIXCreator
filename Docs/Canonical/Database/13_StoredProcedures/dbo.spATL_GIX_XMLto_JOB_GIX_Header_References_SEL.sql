SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--declare @ID_Req as BigInt
--declare	@Ref_Type VARCHAR(100)
--set @ID_Req = 12668644
--set @Ref_Type = 'ImportForwarderRefNbr'
--spATL_GIX_XMLto_JOB_GIX_Header_References_SEL '12668644','ImportForwarderRefNbr'

CREATE procedure [dbo].[spATL_GIX_XMLto_JOB_GIX_Header_References_SEL]--41
(	
	@ID_Req as BigInt,
	@Ref_Type VARCHAR(100)
)
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
from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = @Ref_Type--'ImportForwarderRefNbr'
	join vwALL_JOBs V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC =5
	join ATL_INT.dbo.GIX_Header_References EntryNumber with(nolock) on EntryNumber.ID_Req = Request.ID_Req 
		and EntryNumber.Ref_Type = 'EntryNumber'
	join ATL_INT.dbo.GIX_Header_Status DTREGISTRO with(nolock) on DTREGISTRO.ID_Req = Request.ID_Req and DTREGISTRO.StatusDescription = 'DTREGISTRO'	
Where
	Request.ID_Req = @ID_Req
	and EntryNumber.Ref_Number is not null
	--and SystemCode = '1'
	and PO.Numero_PO is null
	and RIGHT(DTREGISTRO.StatusDate,4) > 2000
	and left(UPPER(ImportForwarderRefNbr.Ref_Number),1) = 'I'
	
UNION ALL

Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],	
	Licence.LicenceNumber						[Numero_PO],
	''											[DATA],
	'23'										[ID_DC],
	'023 - LI Number'							[Nome_DC],
	'ATL System'									[Usuario],
	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = @Ref_Type
	join vwALL_JOBs V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC =23
	join ATL_INT.dbo.GIX_Header_License Licence with(nolock) on Licence.ID_Req = Request.ID_Req	
Where
	Request.ID_Req = @ID_Req
	and Licence.LicenceNumber is not null
	--and SystemCode = '1'
	and PO.Numero_PO is null	
	and left(UPPER(ImportForwarderRefNbr.Ref_Number),1) = 'I'
	
	
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
from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = @Ref_Type
	join vwALL_JOBs V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 2
	join ATL_INT.dbo.GIX_Header_Commercial_Invoice Invoice with(nolock) on Invoice.ID_Req = Request.ID_Req
Where
	Request.ID_Req = @ID_Req
	and Invoice.Invoice_Number is not null
	--and SystemCode = '1'
	and PO.Numero_PO is null
	and RIGHT(Invoice.CIDate,4) > 2000
	and left(UPPER(ImportForwarderRefNbr.Ref_Number),1) = 'I'
	
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
from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = @Ref_Type
	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 10
	join ATL_INT.dbo.GIX_Detail_ProductDetail ProductDetail with(nolock) on ProductDetail.ID_Req = Request.ID_Req
			
	join ATL_INT.dbo.GIX_Detail_ProductReferences DeliveryNote with(nolock) on DeliveryNote.ID_Req = ProductDetail.ID_Req 
		and DeliveryNote.ID_Detail = ProductDetail.ID_Detail and DeliveryNote.ProductReferences_Type = 'DeliveryNote'
	join ATL_INT.dbo.GIX_Detail_ProductDates ProductDates with(nolock) on ProductDates.ID_Req = ProductDetail.ID_Req 
		and ProductDates.ID_Detail = ProductDetail.ID_Detail 
Where
	Request.ID_Req = @ID_Req
	and DeliveryNote.ProductReferenceNumber	is not null
	--and SystemCode = '1'
	and PO.Numero_PO is null
	and RIGHT(ProductDates.ProductDatesDate,4) > 2000
	and left(UPPER(ImportForwarderRefNbr.Ref_Number),1) = 'I'

--UNION ALL
--2.2.1 - when job>references>nrosimi - GIX>References Type: GovernmentPermissionToExportReleaseNumber 
--- JOB>Ref.>Customer Reference>SIMI
--SELECT * FROM atl_int.dbo.GIX_HEADER_References WHERE ID_Req = '2380402'
--Select 	
--	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
--	Reference.Ref_Number							[Numero_PO],
--	CONVERT(DATETIME,Reference.ReferenceDate,103)				[DATA],
--	'?'												[ID_DC],	
--	'?'												[Nome_DC],
--	'ATL System'									[Usuario],		
--	Request.ID_Req
--from ATL_INT.dbo.GIX_Request_Header Request
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type = @Ref_Type
--	join vwClienteALLJOBS V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	left Join vwPO PO on PO.Num_Proc = V.Num_Proc and PO.ID_DC = '?'
--	left join ATL_INT.dbo.GIX_Header_References Reference on Reference.ID_Req = Request.ID_Req 
--		and Reference.Ref_Type = 'GovernmentPermissionToExportReleaseNumber'
--Where
--	Request.ID_Req = @ID_Req
--	and Reference.Ref_Number is not null
--	and PO.Numero_PO is null

--UNION ALL

----@Rosangela - Pibernat Export Integration - Ticket: 100-73169 - Thu 2/24/2022 4:20 PM
----Esta informação não estamos recebendo com a data da fatura, não devemos atualizar
----2.2.2 - when job>references>reference>referencenumber\InvoiceNumber - GIX>References Type: InvoiceNumber  
----- JOB>Reference>002-INVOICE
----SELECT * FROM atl_int.dbo.GIX_HEADER_References WHERE ID_Req = '2380402'
--Select 	
--	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
--	Reference.Ref_Number							[Numero_PO],
--	CONVERT(DATETIME,Reference.ReferenceDate,103)	[DATA],
--	'2'												[ID_DC],	
--	'002-INVOICE'									[Nome_DC],
--	'ATL System'									[Usuario],		
--	Request.ID_Req
--from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type =@Ref_Type--'BDPJobNumber'
--	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 2
--	left join ATL_INT.dbo.GIX_Header_References Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
--		and Reference.Ref_Type = 'InvoiceNumber'
--Where
--	Request.ID_Req = @ID_Req --2380402
--	and Reference.Ref_Number is not null
--	and PO.Numero_PO is null
--	and left(UPPER(ImportForwarderRefNbr.Ref_Number),1) = 'E'

--UNION ALL


----2.2.3 - when job>references>reference>referencenumber\EntryNumber - GIX>References Type: EntryNumber 
----- JOB>Reference>204-DUE
----SELECT * FROM atl_int.dbo.GIX_HEADER_References WHERE ID_Req = '2380402'
--Select 	
--	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
--	Reference.Ref_Number							[Numero_PO],
--	CONVERT(DATETIME,Reference.ReferenceDate,103)	[DATA],
--	'204'											[ID_DC],	
--	'204-DUE'										[Nome_DC],
--	'ATL System'									[Usuario],		
--	Request.ID_Req
--from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type =@Ref_Type --'BDPJobNumber'
--	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 204
--	left join ATL_INT.dbo.GIX_Header_References Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
--		and Reference.Ref_Type = 'EntryNumber'
--Where
--	Request.ID_Req = @ID_Req -- 2380402 
--	and Reference.Ref_Number is not null
--	and PO.Numero_PO is null
--		and left(UPPER(ImportForwarderRefNbr.Ref_Number),1) = 'E'

--UNION ALL

----2.2.4 - when job>references>reference>referencenumber\CertOriginNumber - GIX>References Type: CertOriginNumber 
----- JOB>Reference>013-Certificado de Origem
----SELECT * FROM atl_int.dbo.GIX_HEADER_References WHERE ID_Req = '2380402'
--Select 	
--	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
--	Reference.Ref_Number							[Numero_PO],
--	CONVERT(DATETIME,Reference.ReferenceDate,103)	[DATA],
--	'13'											[ID_DC],	
--	'013-Certificado de Origem'						[Nome_DC],
--	'ATL System'									[Usuario],		
--	Request.ID_Req
--from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type =@Ref_Type --'BDPJobNumber'
--	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 13
--	left join ATL_INT.dbo.GIX_Header_References Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
--		and Reference.Ref_Type = 'CertOriginNumber'
--Where
--	Request.ID_Req = @ID_Req -- 2380402 
--	and Reference.Ref_Number is not null
--	and PO.Numero_PO is null
--		and left(UPPER(ImportForwarderRefNbr.Ref_Number),1) = 'E'



--UNION ALL

----2.2.5 - when job>notafiscalsaida>numero - GIX>GIX_Header_BDPInvoice\InvoiceNumber 
----- 010 - JOB>Reference>010 - Nota Fiscal
----SELECT * FROM atl_int.dbo.GIX_Header_BDPInvoice WHERE ID_Req = '2380402'
--Select 	
--	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
--	Reference.InvoiceNumber							[Numero_PO],
--	CONVERT(DATETIME,Reference.InvoiceDate,103)		[DATA],
--	'10'											[ID_DC],	
--	'010 - Nota Fiscal'								[Nome_DC],
--	'ATL System'									[Usuario],		
--	Request.ID_Req
--from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type =@Ref_Type --'BDPJobNumber'
--	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 10
--	left join ATL_INT.dbo.GIX_Header_BDPInvoice Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
--Where
--	Request.ID_Req = @ID_Req  -- 2380402 
--	and Reference.InvoiceNumber is not null
--	and PO.Numero_PO is null
--		and left(UPPER(ImportForwarderRefNbr.Ref_Number),1) = 'E'

--UNION ALL
----2.2.6 - when job>references>reference>referenceruc  - GIX>GIX_Header_Commercial_Invoice\Invoice_Number 
----- JOB>Reference>205-RUC
----SELECT * FROM atl_int.dbo.GIX_Header_Commercial_Invoice WHERE ID_Req = '2380402'
--Select 	
--	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
--	Reference.Invoice_Number						[Numero_PO],
--		(case when (Reference.CIDate = '' OR Reference.CIDate IS NULL) then ''
--	else  
--	RIGHT(Reference.CIDate,4)+'-'
--		+ left(Reference.CIDate,2) + '-'
--		+ substring(Reference.CIDate,3,2) end)				[DATA],
--	'205'											[ID_DC],	
--	'205-RUC'						[Nome_DC],
--	'ATL System'									[Usuario],		
--	Request.ID_Req
--from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type =@Ref_Type --'BDPJobNumber'
--	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 205
--	left join ATL_INT.dbo.GIX_Header_Commercial_Invoice Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
--Where
--	Request.ID_Req = @ID_Req -- 2380402 
--	and Reference.Invoice_Number is not null
--	and PO.Numero_PO is null
--		and left(UPPER(ImportForwarderRefNbr.Ref_Number),1) = 'E'

--UNION ALL

----2.2.7 - when job>references>reference>referencechaveacesso  - GIX>GIX_Header_Commercial_Invoice\ReferenceNumber
---- - JOB>Reference>209-Chave Acesso DUE
----SELECT * FROM atl_int.dbo.GIX_HEADER_References WHERE ID_Req = '2380402'
--Select 	
--	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
--	Reference.ReferenceNumber						[Numero_PO],
--		(case when (Reference.CIDate = '' OR Reference.CIDate IS NULL) then ''
--	else  
--	RIGHT(Reference.CIDate,4)+'-'
--		+ left(Reference.CIDate,2) + '-'
--		+ substring(Reference.CIDate,3,2) end)				[DATA],
--	'209'											[ID_DC],	
--	'209-Chave Acesso DUE'							[Nome_DC],
--	'ATL System'									[Usuario],		
--	Request.ID_Req
--from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type =@Ref_Type --'BDPJobNumber' 
--	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 209
--	left join ATL_INT.dbo.GIX_Header_Commercial_Invoice Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
--Where
--	Request.ID_Req = @ID_Req -- 2380402 
--	and Reference.ReferenceNumber is not null
--	and PO.Numero_PO is null
--		and left(UPPER(ImportForwarderRefNbr.Ref_Number),1) = 'E'


GO
