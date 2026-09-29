SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pPessoaPagRec_Sel 
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
					Apelido  = @Apelido and PgtoRcto = 1		
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
									Desat_Pes = @Desat_Pes  and PgtoRcto = 1
								Order by 
									Apelido 
							Else
								Select 
									*
								From 
									Pessoa 
								Where
									Nome_Raz_Soc = @Nome_Raz_Soc  and PgtoRcto = 1
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
											Desat_Pes = @Desat_Pes and PgtoRcto = 1
										Order by 
											Apelido 
									Else
										Select 
											*
										From 
											Pessoa 
										Where
											Cd_Tp_Classe = @Tp_Classe and PgtoRcto = 1			
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
											Desat_Pes = @Desat_Pes and PgtoRcto = 1
										Order by 
											Apelido 
									Else
										Select 
											*
										From 
											Pessoa 
										Where
											PgtoRcto = 1
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
			Cd_Pes = @Cd_Pessoa and PgtoRcto = 1
		Order by 
			Apelido
GO
