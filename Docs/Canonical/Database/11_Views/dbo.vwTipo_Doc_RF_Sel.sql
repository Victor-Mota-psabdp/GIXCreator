SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTipo_Doc_RF_Sel]
AS
SELECT     Code, [Type Lancamento]
FROM         (SELECT     cd_tipo_doc_RF AS Code,Descricao_tp_doc AS [Type Lancamento]
                       FROM          dbo.Tipo_Doc_RF
                       WHERE      (Ativo = 'S')) AS Alias



GO
