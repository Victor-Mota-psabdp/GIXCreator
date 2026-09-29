SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create       procedure [dbo].[spTipo_Range_Cp_InsUpd]

	
	@codigo		varchar(1),
	@descricao	varchar(30),
	@modal		varchar(1)

AS

Begin Transaction

	IF  exists(
		SELECT
			Cd_range,range_descricao,modal
		FROM
			TIPO_Range_Cp

		WHERE
			Cd_range=@codigo
		)


	BEGIN
		UPDATE
			TIPO_Range_Cp
		SET
			range_descricao = @descricao,
			modal = @modal
		WHERE
			Cd_range=@codigo
	END
	ELSE
		INSERT
			TIPO_Range_cp(
				Cd_range, range_descricao, modal
				)
		Values
			(
				@codigo, @descricao, @modal
			)

Commit Transaction

GO
