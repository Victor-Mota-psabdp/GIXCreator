SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spATL_E_Mix_Consulta_Tipo_InsUpd]
(
	@ID_Consulta_Tipo int,
	@Nome_Consulta_Tipo varchar(30)
)

AS

Begin Transaction

	If  exists (select ID_Consulta_Tipo from E_Mix_Consulta_Tipo where ID_Consulta_Tipo=@ID_Consulta_Tipo)
	Begin
		Update
			E_Mix_Consulta_Tipo
		Set
			Nome_Consulta_Tipo=@Nome_Consulta_Tipo
		Where
			ID_Consulta_Tipo=@ID_Consulta_Tipo
	End
	Else
		Insert
			E_Mix_Consulta_Tipo(ID_Consulta_Tipo,Nome_Consulta_Tipo)
		Values
			(@ID_Consulta_Tipo,@Nome_Consulta_Tipo)
	

Commit Transaction





GO
