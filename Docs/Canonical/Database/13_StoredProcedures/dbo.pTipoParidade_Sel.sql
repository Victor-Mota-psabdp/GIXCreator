SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pTipoParidade_Sel    Script Date: 17/10/2002 07:32:52 ******/
CREATE PROCEDURE pTipoParidade_Sel 
(
@Cd_Tp_Par		VarChar(3)='',
@Nome_Tp_Par	VarChar(30)=''
)
 AS
	If @Cd_Tp_Par <> ''
		Select 
			*
		From 
			Tipo_paridade
		Where
			Cd_Tp_Par = @Cd_Tp_Par
		Order by 
			Nome_Tp_Par
	Else
		Begin 
			If @Nome_Tp_Par <> '' 
				Select 
					*
				From 
					Tipo_paridade
				Where
					Nome_Tp_Par = @Nome_Tp_Par
				Order by 
					Nome_Tp_Par
			Else 
				Select 
					*
				From 
					Tipo_paridade
				Order by 
					Nome_Tp_Par
		End



GO
