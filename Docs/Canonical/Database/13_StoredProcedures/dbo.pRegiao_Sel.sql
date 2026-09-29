SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pRegiao_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pRegiao_Sel 
(
@Cd_Regiao		Char(3)='', 
@Nome_Regiao 	VarChar(30)=''
)
 AS
	If @Cd_Regiao <> '' 
		Select 
			*
		From 
			Regiao 
		Where
			Cd_Regiao = @Cd_Regiao 
	Else
		Begin 
			If @Nome_Regiao <> '' 
				Select 
					*
				From 
					Regiao 
				Where 
					Nome_Regiao = @Nome_Regiao 
			Else 
				Select 
					*
				From 
					Regiao 
			end



GO
