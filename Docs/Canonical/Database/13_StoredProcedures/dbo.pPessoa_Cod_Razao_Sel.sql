SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pPessoa_Cod_Razao_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPessoa_Cod_Razao_Sel 
(
@Cd_Pessoa		VarChar(10)='',
@Desat_Pes		Char(1)=''
)
 AS
	If @Cd_Pessoa <> ''
		Begin 
			If @Desat_Pes <>  '' 
				Select 
					Cd_Pes, Nome_Raz_Soc
				From 
					Pessoa 
				Where
					Cd_Pes = @Cd_Pessoa and 
					Desat_Pes  = @Desat_Pes
				Order by
					Nome_Raz_Soc
			Else
				Select 
					Cd_Pes, Nome_Raz_Soc
				From 
					Pessoa 
				Where
					Cd_Pes = @Cd_Pessoa 
				Order by
					Nome_Raz_Soc
		End 
		
	Else
		Begin 
			If @Desat_Pes <>  '' 
				Select 
					Cd_Pes, Nome_Raz_Soc
				From 
					Pessoa 
				Where
					Desat_Pes  = @Desat_Pes
				Order by
					Nome_Raz_Soc
			Else
				Select 
					Cd_Pes, Nome_Raz_Soc
				From 
					Pessoa 
				Order by
					Nome_Raz_Soc
		End



GO
