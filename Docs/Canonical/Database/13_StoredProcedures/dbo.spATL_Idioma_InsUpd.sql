SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Idioma
CREATE PROCEDURE [dbo].[spATL_Idioma_InsUpd]

			@Cd_Idioma char(3),
			@Nome_Idioma varchar(30)

AS

Begin Transaction

	If  exists (select Cd_Idioma from Idioma where Cd_Idioma=@Cd_Idioma)
	Begin
		Update
			Idioma
		Set
			Nome_Idioma=@Nome_Idioma
		Where
			Cd_Idioma=@Cd_Idioma
	End
	Else
		Insert
			Idioma(Cd_Idioma,Nome_Idioma)
		Values
			(@Cd_Idioma,@Nome_Idioma)
	

Commit Transaction





GO
