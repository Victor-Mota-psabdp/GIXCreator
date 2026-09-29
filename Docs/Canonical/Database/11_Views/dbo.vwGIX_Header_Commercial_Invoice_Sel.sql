SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGIX_Header_Commercial_Invoice_Sel]
AS
	select distinct TermsofSaleCode from ATL_INT.dbo.GIX_Header_Commercial_Invoice --ORDER BY 1

GO
