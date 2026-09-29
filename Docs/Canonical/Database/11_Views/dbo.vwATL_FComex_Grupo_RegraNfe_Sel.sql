SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwATL_FComex_Grupo_RegraNfe_Sel]
AS
SELECT	Id_Regra, Id_Empresa, CNPJ, CD_USUARIO, Ativo, Dt_Ins,Id_Status
FROM ATL_INT.dbo.FComex_Grupo_RegraNfe
      

GO
