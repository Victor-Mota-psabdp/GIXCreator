SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMEM_Master_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMEM_Master_Sel
(
@Master 		VarChar(25)=''
)
AS
	If @Master  <> '' 
		Select 
			MAWB_MEM
		From 
			Master_Exp_mar
		Where 
			MAWB_MEM = @Master
	Else
		Select 
			MAWB_MEM
		From 
			Master_Exp_mar
		Order by
			MAWB_MEM



GO
