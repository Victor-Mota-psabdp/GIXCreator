SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwArea_Sel]
AS
SELECT     Code, [Department Name]
FROM         (SELECT Cd_Area AS Code,Nome_Area AS [Department Name]
				FROM  dbo.Area) AS ALIAS
             
                       








GO
