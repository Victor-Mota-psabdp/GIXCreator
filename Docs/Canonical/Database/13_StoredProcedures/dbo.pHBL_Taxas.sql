SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHBL_Taxas 
(
@Processo	VarChar(16)
)
AS
	Select 
		* 
	From 
		HBL_Taxas HT 
		Join Tipo_Taxa Tx on Tx.Cd_Tp_Tx = HT.Cd_Tp_Tx 
		Join Cta_Cte_Hou_Exp_Mar Cte on Cte.Num_Proc_HEM = HT.Num_Proc and Cte.DC_HEM = 'C' and Cte.Cd_Tp_Tx = HT.Cd_Tp_Tx 
	Where 
		HT.Num_Proc = @Processo

GO
