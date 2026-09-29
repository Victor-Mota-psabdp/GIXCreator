SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHEMHIMProc_Sel  
(
@Order 	Char(1)='P'
)
AS
	If @Order = 'P'
		Select 
			Num_Proc_HEM as Processo, HAWB_HEM 
		From 
			House_Exp_Mar
		Where
			Left(Num_Proc_HEM, 3) <> 'JOB'
		
		Union 
	
		Select 
			Num_Proc_HIM as Processo, HAWB_HIM 
		From 
			House_Imp_Mar
		Where
			Left(Num_Proc_HIM, 3) <> 'JOB'
	
		Order by 
			Processo
	Else 
		Select 
			Num_Proc_HEM, HAWB_HEM as House 
		From 
			House_Exp_Mar
		Where
			Left(Num_Proc_HEM, 3) <> 'JOB'

		Union 
	
		Select 
			Num_Proc_HIM, HAWB_HIM as House 
		From 
			House_Imp_Mar
		Where
			Left(Num_Proc_HIM, 3) <> 'JOB'
	
		Order by 
			House

GO
