SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pDiv_Lucro_Sel    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pDiv_Lucro_Sel 
(
@Cd_Parceiro		VarChar(10)='',
@Apelido		VarChar(20)='',
@Perc_DL		Float = Null  
)
 AS
	If @Cd_Parceiro <> '' 
		Begin 
			If @Perc_DL = Null 
				Select 
					*
				From 
					Div_Lucro
				Where 
					Cd_Parceiro = @Cd_Parceiro 
				Order by 
					Perc_DL	
			Else
				Select 
					*
				From 
					Div_Lucro
				Where 
					Cd_Parceiro = @Cd_Parceiro and 
					Perc_DL = @Perc_DL
				Order by 
					Perc_DL	
		End 
	Else 
		Begin 
			If @Apelido <> '' 
				Select 
					Cd_Parceiro, 
					Perc_DL
				From 
					Pessoa as P, 
					Div_Lucro as D 
				Where  
					D.Cd_parceiro = P.Cd_pes and 
					P.Apelido = @Apelido 
				Order by 
					Perc_DL	
			Else 
				Begin 
					If @Perc_DL <>  Null 
						Select 
							Cd_Parceiro, 
							Perc_DL
						From 
							Pessoa as P, 
							Div_Lucro as D 
						Where  
							D.Cd_parceiro = P.Cd_pes and 
							P.Apelido = @Apelido 
						Order by 
							Perc_DL				
					Else
						Select 
							Distinct Perc_DL
						From 
							Div_Lucro
				End 
		End



GO
