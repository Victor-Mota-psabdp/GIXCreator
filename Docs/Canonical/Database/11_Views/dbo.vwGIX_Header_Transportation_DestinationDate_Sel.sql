SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGIX_Header_Transportation_DestinationDate_Sel]
AS
	select distinct Type from ATL_INT.dbo.GIX_Header_Transportation_DestinationDate --ORDER BY 1

GO
