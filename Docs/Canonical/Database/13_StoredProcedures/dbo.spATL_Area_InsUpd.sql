SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_Area_InsUpd]

			@Cd_Area char(3),
			@Nome_Area varchar(30)

AS

Begin Transaction

	If  exists (select Cd_Area from Area where Cd_Area=@Cd_Area)
	Begin
		Update
			Area
		Set
			Nome_Area=@Nome_Area
		Where
			Cd_Area=@Cd_Area
	End
	Else
		Insert
			Area(Cd_Area,Nome_Area)
		Values
			(@Cd_Area,@Nome_Area)
	

Commit Transaction





GO
