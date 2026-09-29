SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pMIM_CIMC_Sel 
(
@CIMC		VarChar(12)='' 
)
 AS
	If @CIMC <> ''
		Select 
			Distinct 	CIMC_MIM
		From 
			Master_Imp_Mar 
		Where 
			Rtrim(CIMC_MIM ) <> '' and 
			CIMC_MIM is not null and 
			CIMC_MIM = @CIMC
	Else
		Select 
			Distinct 	CIMC_MIM
		From 
			Master_Imp_Mar 
		Where 
			Rtrim(CIMC_MIM ) <> '' and 
			CIMC_MIM is not null



GO
