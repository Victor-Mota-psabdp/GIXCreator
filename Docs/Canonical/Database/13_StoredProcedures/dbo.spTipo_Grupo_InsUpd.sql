SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spTipo_Grupo_InsUpd]
(
	@Cd_Tp_Grupo char(3),
	@Nome_Tp_Grupo varchar(60)
)
AS		
		
Begin Transaction

	If Exists(Select Cd_Tp_Grupo From Tipo_Grupo Where Cd_Tp_Grupo = @Cd_Tp_Grupo)
		Begin
			Update
				Tipo_Grupo
			Set 
				Nome_Tp_Grupo = @Nome_Tp_Grupo
			Where 
				Cd_Tp_Grupo = @Cd_Tp_Grupo
		End
	Else
		Begin
			Insert
				Tipo_Grupo(Cd_Tp_Grupo,Nome_Tp_Grupo)
			Values
				(@Cd_Tp_Grupo,@Nome_Tp_Grupo)
		End
	

Commit Transaction

GO
