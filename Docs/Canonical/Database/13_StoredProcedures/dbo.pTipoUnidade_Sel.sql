SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pTipoUnidade_Sel
(
@Cd_Tp_Unidade	VarChar(3)=''
)
 AS 
	If @Cd_Tp_Unidade <> '' 
		Select 
			*
		From 
			Tipo_Unidade
		Where
			Cd_Tp_Unidade = @Cd_Tp_Unidade		
	Else
		Select 
			*
		From 
			Tipo_Unidade



GO
