SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_LI
CREATE PROCEDURE [dbo].[spATL_Tipo_LI_InsUpd]

		@ID_Tipo	int,
		@Nome_Tp_LI varchar(30)

AS


Begin Transaction

	If  exists (select ID_Tipo from Tipo_LI where ID_Tipo=@ID_Tipo)
	Begin
		Update
			Tipo_LI
		Set
			Nome_Tp_LI=@Nome_Tp_LI
		Where
			ID_Tipo=@ID_Tipo
	End
	Else
		Insert
			Tipo_LI(
				ID_Tipo,
				Nome_Tp_LI
				)
		Values
			(
			@ID_Tipo,	
			@Nome_Tp_LI
		)
	

Commit Transaction

GO
