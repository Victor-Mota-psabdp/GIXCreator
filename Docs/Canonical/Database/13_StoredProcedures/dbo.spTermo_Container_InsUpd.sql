SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Termo_Container
CREATE PROCEDURE [dbo].[spTermo_Container_InsUpd]

		@cd_termo	int,
		@empresa varchar(50)

AS


Begin Transaction

	If  exists (select cd_termo from Termo_Container where cd_termo=@cd_termo)
	Begin
		Update
			Termo_Container
		Set
			empresa=@empresa
		Where
			cd_termo=@cd_termo
	End
	Else
		Insert
			Termo_Container(
				cd_termo,
				empresa
				)
		Values
			(
			@cd_termo,	
			@empresa
		)
	

Commit Transaction

GO
