SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pClasse_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pClasse_Sel 
(
@Cd_Tp_Classe	Char(3)='', 
@Classe		VarChar(30) =''
)
 AS
	If @Cd_Tp_Classe <> '' 
		Select 
			*
		From 
			Tipo_Classe
		Where
			Cd_Tp_Classe  = @Cd_Tp_Classe  
	Else
		Begin 
			If @Classe <> '' 
				Select 
					*
				From 
					Tipo_Classe
				Where 
					Nome_Tp_Classe  = @Classe  
			Else 
				Select 
					*
				From 
					Tipo_Classe 
				Order by 	
					Nome_Tp_Classe
		End



GO
