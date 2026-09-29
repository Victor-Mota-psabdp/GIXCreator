SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCentroCusto_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pCentroCusto_Sel 
(
@Centro_Custo			VarChar(5)='',
@Nome_Centro_Custo		VarChar(30)=''
)
 AS
	If @Centro_Custo <> '' 
		Select 
			*
		From 
			Centro_Custo
		Where 
			Cd_Centro_Custo = @Centro_Custo
	Else
		Begin
			If @Nome_Centro_Custo <> '' 
				Select 
					*
				From 
					Centro_Custo
				Where 
					Nome_Centro_Custo = @Nome_Centro_Custo
			Else 
				Select 
					*
				From 
					Centro_Custo
				Order by 
					Nome_Centro_Custo
		End



GO
