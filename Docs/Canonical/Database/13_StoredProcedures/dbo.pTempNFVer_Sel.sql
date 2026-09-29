SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pTempNFVer_Sel
(
@Id_Machine		VarChar(50)
)
 AS
	
	Select 
		TC.NUM_PROC as Num_Proc , TC.CD_TP_TX, Sum(TC.Vlr_Pago) - IsNull(Sum(TD.Vlr_Pago),0) as ValorItem 
	From 
		Temp_Recibo_NF as TC left Outer Join Temp_Recibo_NF as TD on (TC.Num_Proc = TD.Num_Proc and TC.Cd_Tp_Tx = TD.Cd_Tp_Tx and TC.DC = 'D')
	Where
		TC.DC = 'C'  and TC.ID_Machine = @Id_Machine 
	Group by 
		TC.NUM_PROC, TC.CD_TP_TX	
	Union
	Select 
		Num_Proc as Num_Proc , Cd_Tp_tx, - Vlr_Pago  as ValorItem 
	From 	
		Temp_Recibo_NF as TD
	Where
		DC = 'D' and TD.ID_Machine = @ID_Machine and 
		TD.Cd_Tp_Tx Not In 
		(Select TC.Cd_Tp_Tx From Temp_Recibo_NF as TC Where TC.Num_Proc = TD.Num_Proc and TC.Cd_Tp_Tx = TD.Cd_Tp_Tx and TC.DC = 'C')



GO
