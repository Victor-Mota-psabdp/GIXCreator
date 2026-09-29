SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Grupo_Usuario
CREATE PROCEDURE [dbo].[spATL_Tipo_Grupo_Usuario_InsUpd]

			@ID_Tp_GR_Usuario char(3),
			@Nome_Tp_GR_Usuario varchar(30)

AS

Begin Transaction

	If  exists (select ID_Tp_GR_Usuario from Tipo_Grupo_Usuario where ID_Tp_GR_Usuario=@ID_Tp_GR_Usuario)
	Begin
		Update
			Tipo_Grupo_Usuario
		Set
			Nome_Tp_GR_Usuario=@Nome_Tp_GR_Usuario
		Where
			ID_Tp_GR_Usuario=@ID_Tp_GR_Usuario
	End
	Else
		Insert
			Tipo_Grupo_Usuario(Nome_Tp_GR_Usuario)
		Values
			(@Nome_Tp_GR_Usuario)
	

Commit Transaction

GO
