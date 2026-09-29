SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwTipo_Movimento_Sel]
AS
SELECT     [Id], [Movement Name]
FROM         (SELECT Id AS Id,Nome_Movimento AS [Movement Name]
				FROM  dbo.Tipo_Movimento) AS ALIAS
             
                       








GO
