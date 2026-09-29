SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwFaturasValidasDraft]
AS
SELECT     I.FatCod, I.Num_Proc, I.Cd_Tp_Tx, I.DC, I.Cd_Tp_Moeda, I.Vlr_Org, I.Vlr_RS, I.Paridade, I.Vlr_Cont_Item, F.FatDtEmissao, F.FatDtVenc
FROM         dbo.Fatura_Draft AS F INNER JOIN
                      dbo.Item_Fat_Draft AS I ON I.FatCod = F.FatCod
WHERE     (F.FatStatus <> 0)



GO
