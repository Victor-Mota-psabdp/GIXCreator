SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGIX_Header_Transportation_Carrier_Sel]
AS
	select distinct Value from ATL_INT.dbo.GIX_Header_Transportation_Carrier --ORDER BY 1

GO
