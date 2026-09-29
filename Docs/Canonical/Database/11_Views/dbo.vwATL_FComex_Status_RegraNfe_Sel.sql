SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwATL_FComex_Status_RegraNfe_Sel]
AS
SELECT	Id_Status, Descricao, CD_USUARIO, Dt_Ins
FROM ATL_INT.dbo.FComex_Status_RegraNfe
      

GO
