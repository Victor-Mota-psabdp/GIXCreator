SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spUsuario_Acesso_InsUpd]

	
	@cd_usuario	varchar(6),
	@cd_tela	varchar(3),
	@leitura	char(1),
	@gravacao	char(1),
	@exclusao	char(1)

AS

Begin Transaction

	IF  exists(
		SELECT
			cd_usuario,cd_tela,leitura,gravacao, exclusao
		FROM
			Usuario_Acesso

		WHERE
			Cd_tela=@cd_tela AND
			cd_usuario=@cd_usuario			
		)


	BEGIN
		UPDATE
			Usuario_Acesso
		SET			
			leitura = @leitura,
			gravacao = @gravacao,
			exclusao = @exclusao
		WHERE
			Cd_tela=@cd_tela and
			cd_usuario=@cd_usuario
	END
	ELSE
		INSERT
			Usuario_Acesso(
				Cd_usuario,Cd_tela,leitura, gravacao, exclusao
				)
		Values
			(
				@cd_usuario, @cd_tela, @leitura, @gravacao, @exclusao
			)

Commit Transaction


GO
