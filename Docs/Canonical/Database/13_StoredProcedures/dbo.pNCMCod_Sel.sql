SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pNCMCod_Sel 
(
@NCM			VarChar(9)='' 
)
AS
	If @NCM <> '' 
		Begin 
			Select 
				NCM
			From 	
				NCM
			Where
				NCM like @NCM + '%'
			Order by 
				NCM
		End 
	Else 
		Select 
			NCM
		From 
			NCM
		Order by 
			NCM



GO
