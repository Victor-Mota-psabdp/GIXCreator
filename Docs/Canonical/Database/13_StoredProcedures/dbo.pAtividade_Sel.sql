SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pAtividade_Sel    Script Date: 28/10/2002 14:37:35 ******/
/****** Object:  Stored Procedure dbo.pAtividade_Sel    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pAtividade_Sel 
(
@Cd_Tp_Atividade	Char(3)='', 
@Atividade		VarChar(60) =''
)
 AS
	If @Cd_Tp_Atividade <> '' 
		Select 
			*
		From 
			Tipo_Atividade
		Where
			Cd_Tp_Ativ = @Cd_Tp_Atividade 
	Else
		Begin 
			If @Atividade  <> '' 
				Select 
					*
				From 
					Tipo_Atividade 
				Where 
					Nome_Tp_Ativ = @Atividade 
			Else 
				Select 
					*
				From 
					Tipo_Atividade 
				Order by 	
					Nome_Tp_Ativ
		End



GO
