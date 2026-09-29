SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_GIX_XMLto_JOB_Reflection_SEL] '4','BDPJobNumber'
--update
--updateCompare
--compare

CREATE procedure [dbo].[spATL_GIX_XMLto_JOB_Reflection_SEL]
(
	@SystemCode VARCHAR(25),
	@Ref_Type VARCHAR(100)
)

as

Select 	
	UPPER(ImportForwarderRefNbr.Ref_Number)													[JOB],	
			
	Invoice.Ref_Number																	[2-PO_Modal.Numero_PO_Modal],
	CONVERT(DATETIME,Invoice.ReferenceDate,103)											[2-PO_Modal.Data_PO_Modal],

	DUE.Ref_Number																		[204-PO_Modal.Numero_PO_Modal],
	CONVERT(DATETIME,DUE.ReferenceDate,103)												[204-PO_Modal.Data_PO_Modal],

	CertOriginNumber.Ref_Number															[13-PO_Modal.Numero_PO_Modal],
	CONVERT(DATETIME,CertOriginNumber.ReferenceDate,103)								[13-PO_Modal.Data_PO_Modal],

	Nota_Fiscal.InvoiceNumber															[10-PO_Modal.Numero_PO_Modal],
	CONVERT(DATETIME,Nota_Fiscal.InvoiceDate,103)										[10-PO_Modal.Data_PO_Modal],

	RUC.Invoice_Number																	[205-PO_Modal.Numero_PO_Modal],
	(case when (RUC.CIDate = '' OR RUC.CIDate IS NULL) then NULL
	else  
	RIGHT(RUC.CIDate,4)+'-'+ left(RUC.CIDate,2) + '-'+ substring(RUC.CIDate,3,2) end)	[205-PO_Modal.Data_PO_Modal],

	Chave_Acesso_DUE.ReferenceNumber													[209-PO_Modal.Numero_PO_Modal],
	(case when (Chave_Acesso_DUE.CIDate = '' OR Chave_Acesso_DUE.CIDate IS NULL) then NULL
	else  
	RIGHT(Chave_Acesso_DUE.CIDate,4)+'-'+ left(Chave_Acesso_DUE.CIDate,2) 
		+ '-' + substring(Chave_Acesso_DUE.CIDate,3,2) end)								 [209-PO_Modal.Data_PO_Modal],
	Request.ID_Req
from ATL_INT.dbo.GIX_Request_Header Request
	join ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr on ImportForwarderRefNbr.ID_Req = Request.ID_Req 
		and ImportForwarderRefNbr.Ref_Type = 'BDPJobNumber'
	join vwALL_JOBs V on V.Num_Proc = ImportForwarderRefNbr.Ref_Number

	left join ATL_INT.dbo.GIX_Header_References Invoice with(nolock) on Invoice.ID_Req = Request.ID_Req 
		and Invoice.Ref_Type = 'InvoiceNumber'

	left join ATL_INT.dbo.GIX_Header_References DUE with(nolock) on DUE.ID_Req = Request.ID_Req 
		and DUE.Ref_Type = 'EntryNumber'

	left join ATL_INT.dbo.GIX_Header_References CertOriginNumber with(nolock) on CertOriginNumber.ID_Req = Request.ID_Req 
		and CertOriginNumber.Ref_Type = 'CertOriginNumber'

	left join ATL_INT.dbo.GIX_Header_BDPInvoice Nota_Fiscal with(nolock) on Nota_Fiscal.ID_Req = Request.ID_Req 

	left join ATL_INT.dbo.GIX_Header_Commercial_Invoice RUC with(nolock) on RUC.ID_Req = Request.ID_Req 

	left join ATL_INT.dbo.GIX_Header_Commercial_Invoice Chave_Acesso_DUE with(nolock) on Chave_Acesso_DUE.ID_Req = Request.ID_Req 
	
where

	DT_INS_JOB is null
	and SystemCode = '4'
	and isnull(v.ID_Status,0) not in ('9','5')
	and dt_ins> getdate() -1

order by
	1

GO
