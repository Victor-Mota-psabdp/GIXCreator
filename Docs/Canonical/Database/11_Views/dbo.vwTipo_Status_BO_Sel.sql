SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTipo_Status_BO_Sel]
AS
SELECT     Code, [Status]
FROM         (SELECT  ID_Status AS Code, Status_Descricao AS [Status]
                       FROM          dbo.Tipo_Status_BO
                       WHERE      (Ativo = 'S')) AS Alias





GO
