SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGIX_Header_Transportation_LEGTYPE_Sel]
AS
	select distinct LEGTYPE from ATL_INT.dbo.GIX_Header_Transportation --ORDER BY 1

GO
