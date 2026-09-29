SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTipo_Ocorrencia_Sel]
AS
SELECT     Code, [Nome_Ocorrencia]
FROM         (SELECT  Cd_Tp_Ocor AS Code, Nome_Tp_Ocor AS [Nome_Ocorrencia]
                       FROM          dbo.Tipo_Ocorrencia
				) AS Alias





GO
