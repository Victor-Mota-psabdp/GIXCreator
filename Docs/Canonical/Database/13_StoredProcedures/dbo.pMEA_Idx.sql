SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMEA_Idx
 AS
	Select 
		Num_Proc_MEA, MAWB_MEA
	From 
		Master_Exp_Aer
	Order by 
		Num_Proc_MEA Desc



GO
