SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pHEAHIAProc_Sel  
(
@Order 	Char(1)='P'
)
AS
	If @Order = 'P'
		Select 
			Num_Proc_HEA as Processo, HAWB_HEA 
		From 
			House_Exp_Aer 
		
		Union 
	
		Select 
			Num_Proc_HIA as Processo, HAWB_HIA 
		From 
			House_Imp_Aer 
	
		Order by 
			Processo
	Else 
		Select 
			Num_Proc_HEA, HAWB_HEA as House 
		From 
			House_Exp_Aer 

		Union 
	
		Select 
			Num_Proc_HIA, HAWB_HIA as House 
		From 
			House_Imp_Aer 
	
		Order by 
			House

GO
