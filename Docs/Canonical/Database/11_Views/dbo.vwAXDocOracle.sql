SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vwAXDocOracle]
AS
SELECT DISTINCT NumeroInternoAX, num_proc, cd_tp_tx_Atl, dc, I.id_Ax, I.TaxGroup Tax_Group,H.Invoice_Number
FROM         Ax_Doc_ITem_Oracle I WITH (nolock) JOIN
                      AX_DOC_Oracle H WITH (nolock) ON I.id_Ax = H.id_ax
WHERE     dt_canc IS NULL AND len(isnull(NumeroInternoAX, '1')) <> 14
UNION ALL
SELECT DISTINCT NumeroInternoAX, NumeroInternoAX, cd_tp_tx_Atl, dc, I.id_Ax, I.TaxGroup Tax_Group,H.Invoice_Number
FROM         Ax_Doc_ITem_Oracle I WITH (nolock) JOIN
                      AX_DOC_Oracle H WITH (nolock) ON I.id_Ax = H.id_ax
WHERE     dt_canc IS NULL AND len(isnull(NumeroInternoAX, '1')) = 14
UNION ALL
SELECT DISTINCT LEFT(Invoice_Number, 14) NumeroInternoAX, LEFT(Invoice_Number, 14) NumeroInternoAX, cd_tp_tx_Atl, dc, I.id_Ax, I.TaxGroup Tax_Group,H.Invoice_Number
FROM         Ax_Doc_ITem_Oracle I WITH (nolock) JOIN
                      AX_DOC_Oracle H WITH (nolock) ON I.id_Ax = H.id_ax
WHERE     dt_canc IS NULL AND len(isnull(Invoice_Number, '1')) = 15

GO
