SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCxaMEA_Sel 
(
@Num_Proc_MEA	VarChar(16),
@Cd_Tp_Tx		VarChar(3), 
@DC_MEA		Char(1)
)
 AS
	Select 
		*
	From 
		Caixa_Mas_Exp_Aer
	Where 
		Num_Proc_MEA = @Num_Proc_MEA  AND 
		Cd_Tp_Tx = @Cd_Tp_Tx AND 
		DC_MEA = @DC_MEA
	Order by 
		Num_Lcto



GO
