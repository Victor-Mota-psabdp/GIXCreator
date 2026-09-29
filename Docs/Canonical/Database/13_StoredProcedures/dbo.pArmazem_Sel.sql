SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pArmazem_Sel    Script Date: 28/10/2002 14:37:35 ******/
/****** Object:  Stored Procedure dbo.pArmazem_Sel    Script Date: 17/10/2002 07:32:46 ******/
CREATE PROCEDURE pArmazem_Sel 
(
@Cd_Armazem 		VarChar(3)='', 
@Armazem 		VarChar(30)=''
)
 AS
	If @Cd_Armazem <> '' 
		Select 
			*	
		From 	
			Armazem 
		Where
			 Cd_Armazem = @Cd_Armazem 
	Else
		Begin 
			If @Armazem <> '' 
				Select 
					*
				From 
					Armazem 
				Where
					Nome_Armazem = @Armazem 
			Else 
				Select 
					*
				From 
					Armazem 
				Order by 
					Nome_Armazem 
		End



GO
