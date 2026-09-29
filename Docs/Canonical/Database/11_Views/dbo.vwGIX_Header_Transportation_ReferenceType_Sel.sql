SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGIX_Header_Transportation_ReferenceType_Sel]
AS
	select distinct type from ATL_INT.dbo.GIX_Header_Transportation_ReferenceType --ORDER BY 1

GO
