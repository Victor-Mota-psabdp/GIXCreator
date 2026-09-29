SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pAcesso_Ver    Script Date: 28/10/2002 14:37:35 ******/
/****** Object:  Stored Procedure dbo.pAcesso_Ver    Script Date: 17/10/2002 07:32:46 ******/
CREATE PROCEDURE pAcesso_Ver
(
@Cd_Usuario 		VarChar(6), 
@Cd_Tela		Char(3) =''
)
 AS
	Declare @Cd_Area 	VarChar(5) 
	Set @Cd_Area = IsNull((Select Cd_Area From Usuario Where Cd_Usuario = @Cd_Usuario ), '')
	If @Cd_Tela <> ''
		Begin	
			Select 
				*
			From 
				Acesso 
			Where
				Cd_Usuario = @Cd_Usuario and 
				Cd_Tela = @Cd_Tela 

			Union 

			Select 
				* 
			From 	
				Acesso_Area 
			Where 
				Cd_Area = @Cd_Area and 
				Cd_Tela = @Cd_Tela 

			If @@RowCount = 0 
				Return -1 
			Else 
				Return 1
		End 
	Else
		Select 
			*
		From 
			Acesso 
		Where
			Cd_Usuario = @Cd_Usuario

		Union 

		Select 
			* 
		From 	
			Acesso_Area 
		Where 
			Cd_Area = @Cd_Area 		

		Order by 
			Cd_Tela
GO
