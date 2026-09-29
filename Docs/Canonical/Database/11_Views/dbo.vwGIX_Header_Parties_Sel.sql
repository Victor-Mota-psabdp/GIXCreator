SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGIX_Header_Parties_Sel]
AS
	select distinct Parties_Type from ATL_INT.dbo.GIX_Header_Parties with(nolock)  --ORDER BY 1


GO
