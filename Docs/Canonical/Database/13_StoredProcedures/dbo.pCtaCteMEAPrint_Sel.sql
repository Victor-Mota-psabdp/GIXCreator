SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCtaCteMEAPrint_Sel
(
@Num_Proc	VarChar(14) 
)
AS
	Select 
		Cd_Tp_Tx_Ofc Cd_Tp_Tx, Cd_Tp_Moeda, Vlr_Org_MEA
	From 
		Cta_Cte_Mas_Exp_Aer Cte Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
	Where
		Num_Proc_MEA  = @Num_Proc and 
		Comp_MBL_MEA = 'S'
GO
