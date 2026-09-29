SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGIX_Header_Transportation_Origin_Sel]
AS
	select distinct Origen_Type from ATL_INT.dbo.GIX_Header_Transportation_Origin --ORDER BY 1

GO
