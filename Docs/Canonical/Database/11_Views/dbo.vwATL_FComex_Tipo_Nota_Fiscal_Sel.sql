SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwATL_FComex_Tipo_Nota_Fiscal_Sel]
AS
SELECT	Id, Id_Empresa, Descricao, CD_USUARIO, Ativo, Dt_Ins
FROM ATL_INT.dbo.FComex_Tipo_Nota_Fiscal

GO
