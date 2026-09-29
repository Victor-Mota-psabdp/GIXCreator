SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGIX_Footer_Measurements_Sel]
AS
	select distinct item from ATL_INT.dbo.GIX_Footer_Measurements --ORDER BY 1

GO
