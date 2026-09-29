SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pLocalidade_Sel 
(
@Cd_Local		VarChar(3)='', 
@NomeLocal		VarChar(30)=''
)
 AS
	If @Cd_Local <> ''
		Select 
			Localidade.*, Regiao.*, AP.Descricao_Porto		
		From 
			Localidade Left Outer Join Regiao on Localidade.Cd_Regiao = Regiao.Cd_Regiao 
			Left Outer Join Aux_Portos as AP on Localidade.BITRI = AP.Cd_Porto 
		Where
			Cd_local  = @Cd_local
	Else
		Begin 
			If @NomeLocal <> '' 
				Select 
					Localidade.*, Regiao.*, AP.Descricao_Porto		
				From 	
					Localidade Left Outer Join Regiao on Localidade.Cd_Regiao = Regiao.Cd_Regiao  
					Left Outer Join Aux_Portos as AP on Localidade.BITRI = AP.Cd_Porto 
				Where
					Nome_local = @NomeLocal
			Else
				Select 
					Localidade.*, Regiao.*, AP.Descricao_Porto		
				From 	
					Localidade Left Outer Join Regiao on Localidade.Cd_Regiao = Regiao.Cd_Regiao 
					Left Outer Join Aux_Portos as AP on Localidade.BITRI = AP.Cd_Porto 
				Order by 		
					Nome_Local 		
		End



GO
