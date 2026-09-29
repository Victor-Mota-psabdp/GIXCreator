SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View vwRegistroFinanceiroItem

as

SELECT RFI.Num_Proc,RFI.Cd_Tp_Tx,DC,RFI.Valor_Total,RF.Doc_Number,RF.Dt_Ins [Invoice_Dt]   FROM Registro_Financeiro_Item  RFI
Join Registro_Financeiro rf on rf.Mes=rfi.Mes and rf.Ano = rfi.Ano and rf.Num_Registro = rfi.Num_Registro 
where ativo=1


GO
