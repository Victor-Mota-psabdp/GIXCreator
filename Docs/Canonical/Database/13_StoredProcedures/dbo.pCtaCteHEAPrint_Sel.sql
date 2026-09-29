SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCtaCteHEAPrint_Sel
(
@Num_Proc	VarChar(16) ,
@Tipo		Char(1)
)
AS
	If @Tipo = 'A'
		Select 
			Cd_Tp_Tx_Ofc Cd_Tp_Tx, Cd_Tp_Moeda, Vlr_Org_HEA
		From 
			Cta_Cte_Hou_Exp_Aer as CteC Join Tipo_Taxa TT on TT.Cd_Tp_Tx = CteC.Cd_Tp_Tx 
		Where
			Num_Proc_HEA  = @Num_Proc and 
			Comp_HAWB_HEA = 'S' and 
			CteC.DC_HEA= 'C' and
			CteC.Cd_Tp_Tx not in 
			(Select Cd_Tp_Tx From Cta_Cte_Mas_Exp_Aer  Where Num_Proc_MEA = left(@Num_Proc, 14) and DC_MEA = 'D')
	Else
		Select 
			Cd_Tp_Tx_Ofc Cd_Tp_Tx, Cd_Tp_Moeda, Vlr_Org_HEA
		From 
			Cta_Cte_Hou_Exp_Aer as CteC Join Tipo_Taxa TT on TT.Cd_Tp_Tx = CteC.Cd_Tp_Tx 
		Where
			Num_Proc_HEA  = @Num_Proc and 
			Comp_HAWB_HEA = 'S' and 
			CteC.DC_HEA= 'C' and 
			CteC.Cd_Tp_Tx in 
			(Select Cd_Tp_Tx From Cta_Cte_Mas_Exp_Aer  Where Num_Proc_MEA = Left(@Num_Proc, 14) and DC_MEA = 'D')
GO
