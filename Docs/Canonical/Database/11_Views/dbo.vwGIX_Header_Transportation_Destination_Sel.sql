SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGIX_Header_Transportation_Destination_Sel]
AS
	select distinct Destination_LocationType from 
		ATL_INT.dbo.GIX_Header_Transportation_Destination --ORDER BY 1

GO
