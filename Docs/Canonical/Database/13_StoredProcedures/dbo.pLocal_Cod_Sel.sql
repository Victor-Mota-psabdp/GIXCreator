SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pLocal_Cod_Sel    Script Date: 28/10/2002 14:37:39 ******/
/****** Object:  Stored Procedure dbo.pLocal_Cod_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pLocal_Cod_Sel 
(
@Cd_Local		VarChar(3)='', 
@NomeLocal		VarChar(30)='', 
@Porto			Char(1)='',
@Aeroporto		Char(1)=''
)
 AS
	If @Cd_Local <> ''
		Select 
			Cd_Local,
			Nome_Local 
		From 
			Localidade 
		Where
			Cd_local  = @Cd_local
	Else
		Begin 
			If @NomeLocal <> '' 
				Select 
					Cd_Local,
					Nome_Local 			
				From 	
					Localidade 
				Where
					Nome_local = @NomeLocal
			Else
				Begin 
					If @Porto = 'S'
						Select 
							Cd_Local,
							Nome_Local 			
						From 	
							Localidade 
						Where
							Porto = 'S'
					Else
						If @Aeroporto = 'S'
							Select 
								Cd_Local,
								Nome_Local 			
							From 	
								Localidade 
							Where
								Aerop = 'S'
						Else 
							Select 
								Cd_Local,
								Nome_Local 			
							From 	
								Localidade 
							Order by 
								Nome_local
				End 
			End



GO
