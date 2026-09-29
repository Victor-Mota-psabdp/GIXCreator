SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGIX_Header_Transportation_OriginDate_Sel]
AS
	select distinct Type from ATL_INT.dbo.GIX_Header_Transportation_OriginDate --ORDER BY 1

GO
