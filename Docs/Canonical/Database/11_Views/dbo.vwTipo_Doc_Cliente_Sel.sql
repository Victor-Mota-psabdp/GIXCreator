SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTipo_Doc_Cliente_Sel]
AS
SELECT     Code, [Nome Documento],[Documento]
FROM         (SELECT   right('000' + Convert(varchar(3),ID_DC),3)  AS Code,Nome_DC AS [Nome Documento],
right('000' + Convert(varchar(3),ID_DC),3) + '-' + Nome_DC AS [Documento]
                       FROM          dbo.Tipo_Doc_Cliente 
              ) AS Alias





GO
