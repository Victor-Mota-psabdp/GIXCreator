SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[spArea_InsUpd]

@Codigo varchar(3),
@Nome varchar(30)

AS

Begin Transaction

	If  exists (select Cd_Area from Area where Cd_Area=@Codigo)
	Begin
		Update
			Area
		Set
			Cd_Area=@Codigo,
			Nome_Area=@Nome
		Where
			Cd_Area=@Codigo
	End
	Else
		Insert
			Area(Cd_Area,Nome_Area)
		Values
			(@Codigo, @Nome)
	

Commit Transaction


GO
