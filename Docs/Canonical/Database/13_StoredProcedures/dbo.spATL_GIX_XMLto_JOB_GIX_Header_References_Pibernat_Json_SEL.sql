SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_GIX_XMLto_JOB_GIX_Header_References_Pibernat_Json_SEL] --41
(
    @ID_Req    AS BIGINT,
    @Ref_Type  VARCHAR(100)
)
AS

--@Rosangela - Pibernat Export Integration - Ticket: 100-73169 - Thu 2/24/2022 4:20 PM
--Esta informação não estamos recebendo com a data da fatura, não devemos atualizar
--2.2.2 - when job>references>reference>referencenumber\InvoiceNumber - GIX>References Type: InvoiceNumber  
--JOB>Reference>002-INVOICE
--SELECT * FROM atl_int.dbo.GIX_HEADER_References WHERE ID_Req = '2380402'

	SELECT
		UPPER(ImportForwarderRefNbr.Ref_Number)           AS [JOB],
		Reference.Ref_Number                              AS [Numero_PO],
		CONVERT(DATETIME, Reference.ReferenceDate, 103)   AS [DATA],
		'2'                                               AS [ID_DC],
		'002-INVOICE'                                     AS [Nome_DC],
		'ATL System'                                      AS [Usuario],
		Request.ID_Req
	FROM ATL_INT.dbo.GIX_Request_Header Request WITH (NOLOCK)
	JOIN ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr WITH (NOLOCK) ON ImportForwarderRefNbr.ID_Req = Request.ID_Req AND ImportForwarderRefNbr.Ref_Type = @Ref_Type
	JOIN vwClienteALLJOBS V WITH (NOLOCK) ON V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	LEFT JOIN vwPO PO WITH (NOLOCK) ON PO.Num_Proc = V.Num_Proc AND PO.ID_DC = 2
	LEFT JOIN ATL_INT.dbo.GIX_Header_References Reference WITH (NOLOCK) ON Reference.ID_Req = Request.ID_Req AND Reference.Ref_Type = 'InvoiceNumber'
	WHERE
		Request.ID_Req = @ID_Req
		AND Reference.Ref_Number IS NOT NULL
		AND PO.Numero_PO IS NULL
		AND LEFT(UPPER(ImportForwarderRefNbr.Ref_Number), 1) = 'E'

UNION ALL

--2.2.3 - EntryNumber / 204-DUE
	SELECT
		UPPER(ImportForwarderRefNbr.Ref_Number)           AS [JOB],
		Reference.Ref_Number                              AS [Numero_PO],
		CONVERT(DATETIME, Reference.ReferenceDate, 103)   AS [DATA],
		'204'                                             AS [ID_DC],
		'204-DUE'                                         AS [Nome_DC],
		'ATL System'                                      AS [Usuario],
		Request.ID_Req
	FROM ATL_INT.dbo.GIX_Request_Header Request WITH (NOLOCK)
	JOIN ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr WITH (NOLOCK) ON ImportForwarderRefNbr.ID_Req = Request.ID_Req AND ImportForwarderRefNbr.Ref_Type = @Ref_Type
	JOIN vwClienteALLJOBS V WITH (NOLOCK) ON V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	LEFT JOIN vwPO PO WITH (NOLOCK) ON PO.Num_Proc = V.Num_Proc AND PO.ID_DC = 204
	LEFT JOIN ATL_INT.dbo.GIX_Header_References Reference WITH (NOLOCK) ON Reference.ID_Req = Request.ID_Req AND Reference.Ref_Type = 'EntryNumber'
	WHERE
		Request.ID_Req = @ID_Req
		AND Reference.Ref_Number IS NOT NULL
		AND PO.Numero_PO IS NULL
		AND LEFT(UPPER(Reference.Ref_Number), 1) = 'E'

UNION ALL

	SELECT
		UPPER(ImportForwarderRefNbr.Ref_Number)           AS [JOB],
		Reference.Ref_Number                              AS [Numero_PO],
		CONVERT(DATETIME, Reference.ReferenceDate, 103)   AS [DATA],
		'204'                                             AS [ID_DC],
		'204-DUE'                                         AS [Nome_DC],
		'ATL System'                                      AS [Usuario],
		Request.ID_Req
	FROM ATL_INT.dbo.GIX_Request_Header Request WITH (NOLOCK)
	JOIN ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr WITH (NOLOCK) ON ImportForwarderRefNbr.ID_Req = Request.ID_Req AND ImportForwarderRefNbr.Ref_Type = @Ref_Type
	JOIN vwClienteALLJOBS V WITH (NOLOCK) ON V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	LEFT JOIN vwPO PO WITH (NOLOCK) ON PO.Num_Proc = V.Num_Proc AND PO.ID_DC = 204
	LEFT JOIN ATL_INT.dbo.GIX_Header_References Reference WITH (NOLOCK) ON Reference.ID_Req = Request.ID_Req AND Reference.Ref_Type = 'EntryNumber'
	WHERE
		Request.ID_Req = @ID_Req
		AND Reference.Ref_Number IS NOT NULL
		AND LEFT(UPPER(ImportForwarderRefNbr.Ref_Number), 1) = 'E'
		AND (
			PO.Numero_PO IS NOT NULL
			AND PO.Numero_PO <> Reference.Ref_Number
		)

UNION ALL

--2.2.4 - CertOriginNumber / 013
	SELECT
		UPPER(ImportForwarderRefNbr.Ref_Number)           AS [JOB],
		Reference.Ref_Number                              AS [Numero_PO],
		CONVERT(DATETIME, Reference.ReferenceDate, 103)   AS [DATA],
		'13'                                              AS [ID_DC],
		'013-Certificado de Origem'                       AS [Nome_DC],
		'ATL System'                                      AS [Usuario],
		Request.ID_Req
	FROM ATL_INT.dbo.GIX_Request_Header Request WITH (NOLOCK)
	JOIN ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr WITH (NOLOCK) ON ImportForwarderRefNbr.ID_Req = Request.ID_Req AND ImportForwarderRefNbr.Ref_Type = @Ref_Type
	JOIN vwClienteALLJOBS V WITH (NOLOCK) ON V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	LEFT JOIN vwPO PO WITH (NOLOCK) ON PO.Num_Proc = V.Num_Proc AND PO.ID_DC = 13
	LEFT JOIN ATL_INT.dbo.GIX_Header_References Reference WITH (NOLOCK) ON Reference.ID_Req = Request.ID_Req AND Reference.Ref_Type = 'CertOriginNumber'
	WHERE
		Request.ID_Req = @ID_Req
		AND Reference.Ref_Number IS NOT NULL
		AND PO.Numero_PO IS NULL
		AND LEFT(UPPER(ImportForwarderRefNbr.Ref_Number), 1) = 'E'

UNION ALL

--2.2.6 - Invoice_Number / 205-RUC
	SELECT
		UPPER(ImportForwarderRefNbr.Ref_Number)					AS [JOB],
		Reference.Invoice_Number								AS [Numero_PO],
		CONVERT(DATETIME, EntryNumberRef.ReferenceDate, 103)	AS [DATA],
		'205'													AS [ID_DC],
		'205-RUC'												AS [Nome_DC],
		'ATL System'											AS [Usuario],
		Request.ID_Req
	FROM ATL_INT.dbo.GIX_Request_Header Request WITH (NOLOCK)
	JOIN ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr WITH (NOLOCK) ON ImportForwarderRefNbr.ID_Req = Request.ID_Req AND ImportForwarderRefNbr.Ref_Type = @Ref_Type --'BDPJobNumber'
	JOIN vwClienteALLJOBS V WITH (NOLOCK) ON V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	LEFT JOIN vwPO PO WITH (NOLOCK) ON PO.Num_Proc = V.Num_Proc AND PO.ID_DC = 205
	LEFT JOIN ATL_INT.dbo.GIX_Header_Commercial_Invoice Reference WITH (NOLOCK) ON Reference.ID_Req = Request.ID_Req
	LEFT JOIN ATL_INT.dbo.GIX_Header_References EntryNumberRef WITH (NOLOCK) ON EntryNumberRef.ID_Req = Request.ID_Req AND EntryNumberRef.Ref_Type = 'EntryNumber'
	WHERE
		Request.ID_Req = @ID_Req --24530900
		AND Reference.Invoice_Number IS NOT NULL
		AND (PO.Numero_PO IS NULL OR PO.Numero_PO <> Reference.ReferenceNumber)
		AND LEFT(UPPER(ImportForwarderRefNbr.Ref_Number), 1) = 'E'

UNION ALL

--2.2.7 - ReferenceNumber / 209-Chave Acesso DUE
	SELECT
		UPPER(ImportForwarderRefNbr.Ref_Number)					AS [JOB],
		Reference.ReferenceNumber								AS [Numero_PO],
		CONVERT(DATETIME, EntryNumberRef.ReferenceDate, 103)	AS [DATA],
		'209'													AS [ID_DC],
		'209-Chave Acesso DUE'									AS [Nome_DC],
		'ATL System'											AS [Usuario],
		Request.ID_Req
	FROM ATL_INT.dbo.GIX_Request_Header Request WITH (NOLOCK)
	JOIN ATL_INT.dbo.GIX_Header_References ImportForwarderRefNbr WITH (NOLOCK) ON ImportForwarderRefNbr.ID_Req = Request.ID_Req AND ImportForwarderRefNbr.Ref_Type = @Ref_Type
	JOIN vwClienteALLJOBS V WITH (NOLOCK) ON V.Num_Proc = ImportForwarderRefNbr.Ref_Number
	LEFT JOIN vwPO PO WITH (NOLOCK) ON PO.Num_Proc = V.Num_Proc AND PO.ID_DC = 209
	LEFT JOIN ATL_INT.dbo.GIX_Header_Commercial_Invoice Reference WITH (NOLOCK) ON Reference.ID_Req = Request.ID_Req
	LEFT JOIN ATL_INT.dbo.GIX_Header_References EntryNumberRef WITH (NOLOCK) ON EntryNumberRef.ID_Req = Request.ID_Req AND EntryNumberRef.Ref_Type = 'EntryNumber'
	WHERE
		Request.ID_Req = @ID_Req
		AND Reference.ReferenceNumber IS NOT NULL
		AND (PO.Numero_PO IS NULL OR PO.Numero_PO <> ImportForwarderRefNbr.Ref_Number)
		AND LEFT(UPPER(ImportForwarderRefNbr.Ref_Number), 1) = 'E'

GO
