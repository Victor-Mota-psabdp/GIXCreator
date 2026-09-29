SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_GIX_XMLto_JOB_GIX_Header_References_SEL_TEST]--41
(	
	@ID_Req as BigInt,
	@Ref_Type VARCHAR(100)
)
as
--DUE
--2.2.3 - when job>references>reference>referencenumber\EntryNumber - GIX>References Type: EntryNumber 
--- JOB>Reference>204-DUE
--SELECT * FROM atl_int.dbo.GIX_HEADER_References WHERE ID_Req = '2380402'
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	Reference.Ref_Number							[Numero_PO],
	CONVERT(DATETIME,Reference.ReferenceDate,103)	[DATA],
	'204'											[ID_DC],	
	'204-DUE'										[Nome_DC],
	'ATL System'									[Usuario],		
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type =@Ref_Type --'BDPJobNumber'
	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 204
	left join ATL_INT.dbo.GIX_Header_References Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
		and Reference.Ref_Type = 'EntryNumber'
Where
	Request.ID_Req = @ID_Req -- 24661668 
	and Reference.Ref_Number is not null
	and PO.Numero_PO is null

UNION ALL

--Reference DUE <> PO Job
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	Reference.Ref_Number							[Numero_PO],
	CONVERT(DATETIME,Reference.ReferenceDate,103)	[DATA],
	'204'											[ID_DC],	
	'204-DUE'										[Nome_DC],
	'ATL System'									[Usuario],	
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type =@Ref_Type
	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 204
	left join ATL_INT.dbo.GIX_Header_References Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
		and Reference.Ref_Type = 'EntryNumber'
Where
	Request.ID_Req = @ID_Req 
	and Reference.Ref_Number is not null
	and REPLACE(PO.Numero_PO, '-', '') <> Reference.Ref_Number

UNION ALL
--RUC
--2.2.6 - when job>references>reference>referenceruc  - GIX>GIX_Header_Commercial_Invoice\Invoice_Number 
--- JOB>Reference>205-RUC
--SELECT * FROM atl_int.dbo.GIX_Header_Commercial_Invoice WHERE ID_Req = '2380402'
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	Reference.Ref_Number							[Numero_PO],
	CONVERT(DATETIME,Due.ReferenceDate,103)			[DATA],
	'205'											[ID_DC],	
	'205-RUC'						[Nome_DC],
	'ATL System'									[Usuario],		
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type =@Ref_Type --'BDPJobNumber'
	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 205
	left join ATL_INT.dbo.GIX_Header_References Due with(nolock) on Due.ID_Req = Request.ID_Req 
		and Due.Ref_Type = 'EntryNumber'
	--left join ATL_INT.dbo.GIX_Header_Commercial_Invoice Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
	left join ATL_INT.dbo.GIX_Header_References Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
		and Reference.Ref_Type = 'InvoiceNumber'
Where
	Request.ID_Req = @ID_Req -- 2380402 
	and Reference.Ref_Number is not null
	and PO.Numero_PO is null

UNION ALL
--Reference RUC <> PO Job
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	Reference.Ref_Number							[Numero_PO],
	CONVERT(DATETIME,Due.ReferenceDate,103)			[DATA],
	'205'											[ID_DC],	
	'205-RUC'						[Nome_DC],
	'ATL System'									[Usuario],		
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type =@Ref_Type --'BDPJobNumber'
	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 205
	left join ATL_INT.dbo.GIX_Header_References Due with(nolock) on Due.ID_Req = Request.ID_Req 
		and Due.Ref_Type = 'EntryNumber'
	--left join ATL_INT.dbo.GIX_Header_Commercial_Invoice Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
	left join ATL_INT.dbo.GIX_Header_References Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
		and Reference.Ref_Type = 'InvoiceNumber'
Where
	Request.ID_Req = @ID_Req -- 2380402 
	and Reference.Ref_Number is not null
	and PO.Numero_PO <> Reference.Ref_Number

UNION ALL
--Chave de Acesso
--2.2.7 - when job>references>reference>referencechaveacesso  - GIX>GIX_Header_Commercial_Invoice\ReferenceNumber
-- - JOB>Reference>209-Chave Acesso DUE
--SELECT * FROM atl_int.dbo.GIX_HEADER_References WHERE ID_Req = '2380402'
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	--Reference.ReferenceNumber						[Numero_PO],
	Reference.Ref_Number							[Numero_PO],
	--CONVERT(DATETIME,Reference.CIDate,103)		[DATA],
	CONVERT(DATETIME,Due.ReferenceDate,103)	[DATA],
	'209'											[ID_DC],	
	'209-Chave Acesso DUE'							[Nome_DC],
	'ATL System'									[Usuario],		
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type =@Ref_Type --'BDPJobNumber' 
	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 209
	--left join ATL_INT.dbo.GIX_Header_Commercial_Invoice Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
	left join ATL_INT.dbo.GIX_Header_References Due with(nolock) on Due.ID_Req = Request.ID_Req 
		and Due.Ref_Type = 'EntryNumber'
	left join ATL_INT.dbo.GIX_Header_References Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
		and Reference.Ref_Type = 'BuyerReferenceNumber'
Where
	Request.ID_Req = @ID_Req -- 2380402 
	and Reference.Ref_Number is not null
	and PO.Numero_PO is null

UNION ALL
--Reference Chave de Acesso <> PO Job
Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
	--Reference.ReferenceNumber						[Numero_PO],
	Reference.Ref_Number							[Numero_PO],
	--CONVERT(DATETIME,Reference.CIDate,103)		[DATA],
	CONVERT(DATETIME,Due.ReferenceDate,103)	[DATA],
	'209'											[ID_DC],	
	'209-Chave Acesso DUE'							[Nome_DC],
	'ATL System'									[Usuario],		
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type =@Ref_Type --'BDPJobNumber' 
	join vwClienteALLJOBS V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 209
	--left join ATL_INT.dbo.GIX_Header_Commercial_Invoice Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
	left join ATL_INT.dbo.GIX_Header_References Due with(nolock) on Due.ID_Req = Request.ID_Req 
		and Due.Ref_Type = 'EntryNumber'
	left join ATL_INT.dbo.GIX_Header_References Reference with(nolock) on Reference.ID_Req = Request.ID_Req 
		and Reference.Ref_Type = 'BuyerReferenceNumber'
Where
	Request.ID_Req = @ID_Req -- 2380402 
	and Reference.Ref_Number is not null
	and PO.Numero_PO <> Reference.Ref_Number

	--CAMPOS COMENTADOS PORQUE DEFINIDOS COMO EMPTY
--UNION ALL

--Select 	
--	UPPER(ImportForwarderRefNbr.Ref_Number)			[JOB],
--	Invoice.Invoice_Number						[Numero_PO],
--	(case when (Invoice.CIDate = '' OR Invoice.CIDate IS NULL) then ''
--	else  
--	RIGHT(Invoice.CIDate,4)+'-'
--		+ left(Invoice.CIDate,2) + '-'
--		+ substring(Invoice.CIDate,3,2) end)			[DATA],
--	'2'											[ID_DC],
--	'002 - INVOICE'								[Nome_DC],
--	'ATL System'									[Usuario],
			
--	Request.ID_Req
--from ATL_INT.dbo.GIX_Request_Header Request with(nolock)
--	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr with(nolock) on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
--		and ImportForwarderRefNbr.Ref_Type = @Ref_Type
--	join vwALL_JOBs V with(nolock) on V.Num_Proc = ImportForwarderRefNbr.Ref_Number
--	left Join vwPO PO with(nolock) on PO.Num_Proc = V.Num_Proc and PO.ID_DC = 2
--	join ATL_INT.dbo.GIX_Header_Commercial_Invoice Invoice with(nolock) on Invoice.ID_Req = Request.ID_Req
--Where
--	Request.ID_Req = @ID_Req
--	and Invoice.Invoice_Number is not null
--	--and SystemCode = '1'
--	and PO.Numero_PO is null
	
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
GO
