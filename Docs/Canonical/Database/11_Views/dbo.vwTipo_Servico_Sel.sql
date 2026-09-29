SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTipo_Servico_Sel]
AS
SELECT 
	tp.ID_TP_Servico AS ID, 
	tp.NOME_TP_Servico AS Description
FROM dbo.Tipo_Servico AS tp 





GO
