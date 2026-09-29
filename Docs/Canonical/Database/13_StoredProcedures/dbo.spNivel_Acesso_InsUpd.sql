SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create     procedure [dbo].[spNivel_Acesso_InsUpd]

	
	@cd_area	char(3),
	@cd_tela	char(3),
	@cd_nivel	char(3),
	@leitura	char(1),
	@gravacao	char(1),
	@exclusao	char(1)

AS

Begin Transaction

	IF  exists(
		SELECT
			cd_area,cd_tela,cd_nivel,leitura,gravacao, exclusao
		FROM
			Nivel_Acesso

		WHERE
			Cd_tela=@cd_tela AND
			cd_area=@cd_area And
			cd_nivel=@cd_nivel		
		)


	BEGIN
		UPDATE
			Nivel_Acesso
		SET
			cd_area = @cd_area,
			cd_nivel = @cd_nivel,
			leitura = @leitura,
			gravacao = @gravacao,
			exclusao = @exclusao
		WHERE
			Cd_tela=@cd_tela and
			cd_area=@cd_area and
			cd_nivel=@cd_nivel
	END
	ELSE
		INSERT
			Nivel_Acesso(
				Cd_area,Cd_tela,Cd_nivel,leitura, gravacao, exclusao
				)
		Values
			(
				@cd_area, @cd_tela, @cd_nivel, @leitura, @gravacao, @exclusao
			)

Commit Transaction



GO
