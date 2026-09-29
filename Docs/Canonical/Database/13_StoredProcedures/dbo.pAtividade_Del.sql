SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pAtividade_Del    Script Date: 28/10/2002 14:37:35 ******/
/****** Object:  Stored Procedure dbo.pAtividade_Del    Script Date: 17/10/2002 07:32:46 ******/
CREATE PROCEDURE pAtividade_Del 
(
@Cd_Tp_Ativ 	Char(3)
)
AS
	If Exists(Select * From Tipo_Atividade Where Cd_Tp_Ativ = @Cd_Tp_Ativ)
		Delete From  
			Tipo_Atividade
		Where
			Cd_Tp_Ativ  = @Cd_Tp_Ativ 
	Else
		Return -1



GO
