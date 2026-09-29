SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Usuario_Acesso
CREATE PROCEDURE [dbo].[spATL_Usuario_Acesso_InsUpd]
(	
	@Cd_usuario		varchar(6),
	--@Nome_Usuario	varchar(30),
	@Cd_Tela		varchar(3),
	--@Nome_Tela		varchar(50),	
	@Leitura		char(1),
	@Gravacao		char(1),
	@Exclusao		char(1)
)


AS

Begin Transaction
	
	IF  exists(SELECT cd_usuario FROM Usuario_Acesso WHERE	Cd_tela=@cd_tela AND cd_usuario=@cd_usuario)
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
			Usuario_Acesso
			(
				Cd_usuario,Cd_tela,leitura, gravacao, exclusao
			)
		Values
			(
				@cd_usuario, @cd_tela, @leitura, @gravacao, @exclusao
			)
	

Commit Transaction

GO
