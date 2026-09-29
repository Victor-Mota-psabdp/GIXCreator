SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create     procedure [dbo].[spDep_Acesso_InsUpd]

	
	@cd_area	char(3),
	@cd_tela	char(3),
	@leitura	char(1),
	@gravacao	char(1),
	@exclusao	char(1)

AS

Begin Transaction

	IF  exists(
		SELECT
			cd_area,cd_tela,leitura,gravacao, exclusao
		FROM
			Dep_Acesso

		WHERE
			Cd_tela=@cd_tela AND
			cd_area=@cd_area			
		)


	BEGIN
		UPDATE
			Dep_Acesso
		SET
			cd_area = @cd_area,
			leitura = @leitura,
			gravacao = @gravacao,
			exclusao = @exclusao
		WHERE
			Cd_tela=@cd_tela and
			cd_area=@cd_area
	END
	ELSE
		INSERT
			Dep_Acesso(
				Cd_area,Cd_tela,leitura, gravacao, exclusao
				)
		Values
			(
				@cd_area, @cd_tela, @leitura, @gravacao, @exclusao
			)

Commit Transaction


GO
