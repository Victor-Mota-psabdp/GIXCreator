SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwFaturasValidasCHB_ALLFields]
AS
SELECT	F.Fatura_PC FatCod, F.Processo_PC Num_Proc, 
		F.Data_PC,F.cd_pes_PC,F.BDP_Invoice,		
		I.Cd_Tp_Tx,I.DC,I.Vlr_PC, I.Tp_Pgto,I.Imprime
FROM  dbo.Fatura_CHB AS F INNER JOIN
       dbo.Fatura_CHB_Item AS I ON I.fatura_cc = F.Fatura_PC
WHERE  (Status_PC = 'E' )
		and len(F.Fatura_PC) = 17
	

GO
