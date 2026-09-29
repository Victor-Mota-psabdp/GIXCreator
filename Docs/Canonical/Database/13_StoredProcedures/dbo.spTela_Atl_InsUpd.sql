SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE       procedure [dbo].[spTela_Atl_InsUpd]
	
	@cd_tela		varchar(3),
	@nome_tela		varchar(50),
	@dt_criacao		datetime

AS

Begin Transaction

	IF  exists(
		SELECT
			cd_tela, nome_tela
		FROM
			Tela_atl

		WHERE
			cd_tela=@cd_tela
		)

	BEGIN
		UPDATE
			Tela_atl
		SET
			nome_tela = @nome_tela
		WHERE
			cd_tela=@cd_tela
	END
	ELSE
		INSERT
			Tela_atl(
				cd_tela, nome_tela, dt_criacao
				)
		Values
			(
				@cd_tela, @nome_tela, getdate()
			)

Commit Transaction

GO
