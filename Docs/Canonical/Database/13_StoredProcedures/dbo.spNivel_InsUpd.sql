SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create       procedure [dbo].[spNivel_InsUpd]
	
	@cd_nivel		varchar(3),
	@tipo_nivel		varchar(30)
	
AS

Begin Transaction

	IF  exists(
		SELECT
			Cd_nivel, tipo_nivel
		FROM
			Nivel

		WHERE
			Cd_nivel=@cd_nivel
		)

	BEGIN
		UPDATE
			Nivel
		SET
			tipo_nivel = @tipo_nivel
		WHERE
			cd_nivel=@cd_nivel
	END
	ELSE
		INSERT
			Nivel(
				Cd_nivel, tipo_nivel
				)
		Values
			(
				@cd_nivel, @tipo_nivel
			)

Commit Transaction


GO
