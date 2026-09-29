SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwSite_Sel]
AS
SELECT     Code, [Nome Site]
FROM         (SELECT     cd_site AS Code,Nome_Site AS [Nome Site]
                       FROM dbo.[Site]
                       WHERE      (cd_site is not null)) AS Alias
                       




GO
