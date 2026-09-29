SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwFaturas_CHB_Validas]
AS
SELECT     F.Fatura_PC FatCod, F.Processo_PC Num_Proc, I.Cd_Tp_Tx, I.DC
FROM         dbo.Fatura_CHB AS F INNER JOIN
                      dbo.Fatura_CHB_Item AS I ON I.fatura_cc = F.Fatura_PC
WHERE     (Status_PC = 'E' and Cd_Tipo = 'P')



GO
