SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pAtividade_Upd    Script Date: 28/10/2002 14:37:35 ******/
/****** Object:  Stored Procedure dbo.pAtividade_Upd    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pAtividade_Upd
(
@Cd_Tp_Ativ 	Char(3)='', 
@Atividade 	VarChar(60)=''
)
AS
	If Exists(Select * From Tipo_Atividade Where Cd_Tp_Ativ = @Cd_Tp_Ativ)
		Update
			Tipo_Atividade 
		Set 
			Nome_Tp_Ativ = @Atividade 
		Where 
			Cd_Tp_Ativ = @Cd_Tp_Ativ 
	Else
		Return -1



GO
