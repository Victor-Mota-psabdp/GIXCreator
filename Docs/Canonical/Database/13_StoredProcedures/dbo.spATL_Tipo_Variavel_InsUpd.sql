SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Variavel

CREATE PROCEDURE [dbo].[spATL_Tipo_Variavel_InsUpd]

		@Cd_Tipo	varchar(1),
		@Nome_Tipo varchar(30)

AS

Begin Transaction

	If  exists (select Cd_Tipo from Tipo_Variavel where Cd_Tipo=@Cd_Tipo)
	Begin
		Update
			Tipo_Variavel
		Set
			Nome_Tipo=@Nome_Tipo
		Where
			Cd_Tipo=@Cd_Tipo
	End
	Else
		Insert
			Tipo_Variavel(Cd_Tipo,Nome_Tipo)
		Values
			(@Cd_Tipo,@Nome_Tipo)
	

Commit Transaction





GO
