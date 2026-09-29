SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMIA_Idx
 AS
	Select 
		Num_Proc_MIA, MAWB_MIA
	From 
		Master_Imp_Aer
	Where
		Num_Proc_MIA <> 'JOB'
	Order by 
		Num_Proc_MIA Desc

GO
