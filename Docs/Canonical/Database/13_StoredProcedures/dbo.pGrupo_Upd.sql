SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pGrupo_Upd    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pGrupo_Upd
(
@Cd_Tp_Grupo 	Char(3)='', 
@Grupo 		VarChar(30)=''
)
AS
	If Exists(Select * From Tipo_Grupo Where Cd_Tp_Grupo = @Cd_Tp_Grupo)
		Update
			Tipo_Grupo
		Set 
			Nome_Tp_Grupo = @Grupo
		Where 
			Cd_Tp_Grupo = @Cd_Tp_Grupo
	Else
		Return -1



GO
