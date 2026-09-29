SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGIX_Header_References_Sel]
AS
	select distinct Ref_Type from ATL_INT.dbo.GIX_Header_References --ORDER BY 1

GO
