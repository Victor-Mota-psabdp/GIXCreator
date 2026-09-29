SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGIX_Header_Amount_Sel]
AS
	select distinct AmountType from ATL_INT.dbo.GIX_Header_Amount --ORDER BY 1

GO
