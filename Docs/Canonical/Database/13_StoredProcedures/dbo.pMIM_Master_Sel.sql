SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMIM_Master_Sel    Script Date: 28/10/2002 14:37:40 ******/
/****** Object:  Stored Procedure dbo.pMIM_Master_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMIM_Master_Sel
(
@Master 		VarChar(25)=''
)
AS
	If @Master  <> '' 
		Select 
			MAWB_MIM
		From 
			Master_Imp_Mar
		Where 
			MAWB_MIM = @Master
	Else
		Select 
			MAWB_MIM
		From 
			Master_Imp_Mar
		Order by
			MAWB_MIM



GO
