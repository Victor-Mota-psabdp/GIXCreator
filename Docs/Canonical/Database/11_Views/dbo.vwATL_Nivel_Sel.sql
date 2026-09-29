SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Nivel

CREATE VIEW [dbo].[vwATL_Nivel_Sel]
AS
SELECT     Code,[Level Name]
FROM         (SELECT Cd_Nivel AS Code,Tipo_Nivel AS [Level Name]
				FROM  dbo.Nivel) AS ALIAS
             
       

GO
