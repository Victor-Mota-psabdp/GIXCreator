SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwServico_Sel]
AS
SELECT     Code,cd_site, [Nome Site]
FROM         (SELECT    cd_servico AS Code,cd_site,Item_lei + ' - ' + Descricao AS [Nome Site]
                       FROM dbo.[Tipo_NF_Doc_Register]
                       WHERE   Desativada  = 'N' and  (cd_servico is not null)) AS Alias



GO
