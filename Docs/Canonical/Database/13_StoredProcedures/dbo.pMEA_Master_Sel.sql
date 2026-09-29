SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pMEA_Master_Sel
(
@Master 		VarChar(25)=''
)
AS
	If @Master  <> '' 
		Select 
			MAWB_MEA
		From 
			Master_Exp_Aer
		Where 
			MAWB_MEA = @Master
	Else
		Select 
			MAWB_MEA	
		From 
			Master_Exp_Aer
		Order by
			MAWB_MEA
GO
