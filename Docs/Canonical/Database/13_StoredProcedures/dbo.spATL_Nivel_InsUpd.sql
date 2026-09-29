SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Nivel
CREATE PROCEDURE [dbo].[spATL_Nivel_InsUpd]
		@Cd_Nivel char(3),
		@Tipo_Nivel varchar(30)

AS

Begin Transaction

	If  exists (select Cd_Nivel from Nivel where Cd_Nivel=@Cd_Nivel)
	Begin
		Update
			Nivel
		Set
			Tipo_Nivel=@Tipo_Nivel
		Where
			Cd_Nivel=@Cd_Nivel
	End
	Else
		Insert
			Nivel(Cd_Nivel,Tipo_Nivel)
		Values
			(@Cd_Nivel,@Tipo_Nivel)
	

Commit Transaction





GO
