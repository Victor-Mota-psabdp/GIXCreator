SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Grupo_Acesso
CREATE PROCEDURE [dbo].[spATL_Grupo_Acesso_InsUpd]
(	
	@Cd_Tela		varchar(3),
	@Cd_Pes_Grupo	varchar(10),
	@Leitura		char(1),
	@Gravacao		char(1),
	@Exclusao		char(1)
)


AS

Begin Transaction
	
	IF  exists(SELECT Cd_Tela FROM Grupo_Acesso WHERE 
		Cd_tela=@cd_tela AND Cd_Pes_Grupo = @Cd_Pes_Grupo)
		BEGIN
			UPDATE
				Grupo_Acesso
			SET			
				leitura = @leitura,
				gravacao = @gravacao,
				exclusao = @exclusao
			WHERE
				Cd_tela=@cd_tela AND Cd_Pes_Grupo = @Cd_Pes_Grupo
		END
	ELSE
		INSERT
			Grupo_Acesso
			(
				Cd_Tela,Cd_Pes_Grupo,Leitura, gravacao, exclusao
			)
		Values
			(
				@Cd_Tela,@Cd_Pes_Grupo,@leitura, @gravacao, @exclusao
			)
	

Commit Transaction

GO
