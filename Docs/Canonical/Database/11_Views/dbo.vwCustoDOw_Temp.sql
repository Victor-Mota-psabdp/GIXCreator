SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view vwcustoDow_Temp
As

SELECT     CXA.Cd_Tp_Tx, CXA.Vlr_Pgto_Rcto_HIA, CXA.Num_Proc_HIA
FROM         dbo.vwCXAS AS CXA LEFT OUTER JOIN
                      dbo.Custo_Cliente AS CC ON CXA.Num_Proc_HIA = CC.Num_Proc AND CXA.Cd_Tp_Tx = CC.Cd_tp_tx INNER JOIN
                      dbo.Tipo_Taxa AS TT ON TT.Cd_Tp_Tx = CXA.Cd_Tp_Tx
WHERE     (CXA.Num_Proc_HIA LIKE 'I%CSR%' OR
                      CXA.Num_Proc_HIA LIKE 'I%DEC%') AND (CC.Num_Proc IS NULL) AND (CXA.DC_HIA = 'D') AND (CXA.Cd_Tp_Tx NOT IN ('C01', 'P01', 'XCA', 'CF1', 'BRO', 'DPC', 'XBA', 
                      'BR2', 'VNR', '106', 'AC2', 'AP1', 'ABT', 'AC3', 'C07', 'DNF', 'PBD', 'DVC', 'APC', 'xbc', 'xb2', 'C02', 'P02', 'pis'))
GO
