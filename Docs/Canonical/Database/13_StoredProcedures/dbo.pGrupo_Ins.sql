SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pGrupo_Ins    Script Date: 17/10/2002 07:32:49 ******/
CREATE PROCEDURE pGrupo_Ins 
(
@Cd_Tp_Grupo 	Char(3)='', 
@Grupo 		VarChar(30)=''
)
AS
	If Not Exists(Select * From Tipo_Grupo Where Cd_Tp_Grupo = @Cd_Tp_Grupo)
		Insert Into Tipo_Grupo 
			(Cd_Tp_Grupo, Nome_Tp_Grupo) 
		Values 
			(@Cd_Tp_Grupo, @Grupo ) 
	Else 
		Return -1



GO
