SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create       procedure [dbo].[spTipo_Compra_Venda_Cp_InsUpd]

	
	@codigo		varchar(1),
	@descricao	varchar(30)

AS

Begin Transaction

	IF  exists(
		SELECT
			Cd_cv,descricao_cv
		FROM
			TIPO_COMPRA_VENDA_CP

		WHERE
			Cd_cv=@codigo
		)


	BEGIN
		UPDATE
			TIPO_COMPRA_VENDA_CP
		SET
			descricao_cv = @descricao
		WHERE
			Cd_cv=@codigo
	END
	ELSE
		INSERT
			TIPO_COMPRA_VENDA_CP(
				Cd_cv, descricao_cv
				)
		Values
			(
				@codigo, @descricao
			)

Commit Transaction


GO
