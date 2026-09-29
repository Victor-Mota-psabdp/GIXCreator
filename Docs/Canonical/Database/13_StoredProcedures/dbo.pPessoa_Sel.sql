SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pPessoa_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPessoa_Sel 
(
@Cd_pessoa		VarChar(10)='', 
@Apelido		VarChar(20)='',
@Nome_Raz_Soc	VarChar(60)='' ,
@Tp_Classe		VarChar(3)='',
@Desat_Pes		Char(1)=''
)
 AS
	If @Cd_Pessoa = '' 
		Begin 
			If @Apelido <> '' 
				Select 
					*
				From 
					Pessoa 
				Where
					Apelido  = @Apelido 		
				Order by 
					Apelido 	
			Else
				Begin 
					If @Nome_Raz_Soc <> '' 
						Begin 
							If @Desat_Pes <> ''
								Select 
									*
								From 
									Pessoa 
								Where
									Nome_Raz_Soc = @Nome_Raz_Soc and 
									Desat_Pes = @Desat_Pes 
								Order by 
									Apelido 
							Else
								Select 
									*
								From 
									Pessoa 
								Where
									Nome_Raz_Soc = @Nome_Raz_Soc 
								Order by 
									Apelido 
						End 
					Else
						Begin 
							If @Tp_Classe <>''
								Begin 
									If @Desat_Pes <> ''
										Select 
											*
										From 
											Pessoa 
										Where
											Cd_Tp_Classe = @Tp_Classe and 
											Desat_Pes = @Desat_Pes 
										Order by 
											Apelido 
									Else
										Select 
											*
										From 
											Pessoa 
										Where
											Cd_Tp_Classe = @Tp_Classe			
										Order by 
											Apelido 
								End 
							Else 
								Begin 
									If @Desat_Pes <> ''
										Select 
											*
										From 
											Pessoa 
										Where
											Desat_Pes = @Desat_Pes 
										Order by 
											Apelido 
									Else
										Select 
											*
										From 
											Pessoa 
										Order by 
											Apelido 
								End 
				
						End 
				End 
	
		End 
	Else
		Select 
			* 
		From 
			Pessoa 
		Where 
			Cd_Pes = @Cd_Pessoa
		Order by 
			Apelido
GO
