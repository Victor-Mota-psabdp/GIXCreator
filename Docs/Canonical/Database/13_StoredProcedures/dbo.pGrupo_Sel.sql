SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pGrupo_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pGrupo_Sel 
(
@Cd_Tp_Grupo		Char(3)='', 
@Grupo		VarChar(30) =''
)
 AS
	If @Cd_Tp_Grupo <> '' 
		Select 
			*
		From 
			Tipo_Grupo
		Where
			Cd_Tp_Grupo  = @Cd_Tp_Grupo  
	Else
		Begin 
			If @Grupo <> '' 
				Select 
					*
				From 
					Tipo_Grupo
				Where 
					Nome_Tp_Grupo  = @Grupo  
			Else 
				Select 
					*
				From 
					Tipo_Grupo 
				Order by 	
					Nome_Tp_Grupo
		End



GO
