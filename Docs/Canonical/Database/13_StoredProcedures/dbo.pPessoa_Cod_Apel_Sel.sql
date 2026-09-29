SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pPessoa_Cod_Apel_Sel 
(
@Tp_Classe		VarChar(3)='',
@Desat_Pes		Char(1)=''
)
 AS
	If @Tp_Classe <> '' 
		Begin 
			If  @Desat_Pes = '' 
				Select 
					Cd_Pes, Apelido 			
				From 
					Pessoa
				Where
					Cd_Tp_Classe = @Tp_Classe 
					
				Order by
					Apelido 
			Else
				Select 
					Cd_Pes, Apelido 			
				From 
					Pessoa
				Where
					Cd_Tp_Classe = @Tp_Classe and 
					Desat_Pes = @Desat_Pes 
		End 
	Else
		Begin 
			If  @Desat_Pes = '' 
				Select 
					Cd_Pes, Apelido 			
				From 
					Pessoa
				Order by
					Apelido 
			Else
				Select 
					Cd_Pes, Apelido 			
				From 
					Pessoa
				Where
					Desat_Pes = @Desat_Pes 
				Order by
					Apelido 
		End

GO
