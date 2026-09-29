SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create VIEW [dbo].[vwFaturasValidasArg_Canc]
AS
SELECT     FA.Codigo AS Ref_Accesso_Arg, FA.Numero, FI.ID_Fat, FI.Num_Proc, FI.Cd_Tp_Tx, FI.Cd_tp_Moeda, FI.DC, FI.Valor_Org, FI.Paridade, FI.Valor_ARP, FI.Valor_IVA_ARP, 
                      FA.Dt_Fatura, FA.Cd_Pes AS Cd_Pes_FAT,
					  FA.Status
FROM         dbo.Fatura_ARG_Det AS FI WITH (nolock) INNER JOIN
                      dbo.Fatura_ARG AS FA WITH (nolock) ON FA.ID_Fat = FI.ID_Fat AND FA.Status= 2

GO
