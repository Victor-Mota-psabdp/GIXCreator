SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwCanal_Sel]
AS
select Id AS Code,Canal AS [Channel Name] from Canal with(nolock)
    


GO
