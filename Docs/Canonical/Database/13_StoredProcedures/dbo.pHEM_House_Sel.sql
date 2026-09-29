SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pHEM_House_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pHEM_House_Sel
(
@House 		VarChar(25)=''
)
AS
	If @House  <> '' 
		Select 
			HAWB_HEM
		From 
			House_Exp_mar
		Where 
			HAWB_HEM = @House 
	Else
		Select 
			HAWB_HEM
		From 
			House_Exp_mar
		Order by
			HAWB_HEM



GO
