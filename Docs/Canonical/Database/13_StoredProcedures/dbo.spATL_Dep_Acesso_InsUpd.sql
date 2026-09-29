SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Dep_Acesso
CREATE PROCEDURE [dbo].[spATL_Dep_Acesso_InsUpd]
(	
	@Cd_Area			varchar(3),
	--@Nome_Area		varchar(30),
	@Cd_Tela		varchar(3),
	--@Nome_Tela		varchar(50),
	@Leitura		char(1),
	@Gravacao		char(1),
	@Exclusao		char(1)
)


AS

Begin Transaction

	IF  exists(SELECT Cd_Area FROM Dep_Acesso WHERE	Cd_tela=@cd_tela AND Cd_Area=@Cd_Area)
		BEGIN
			UPDATE
				Dep_Acesso
			SET			
				leitura = @leitura,
				gravacao = @gravacao,
				exclusao = @exclusao
			WHERE
				Cd_tela=@cd_tela and
				Cd_Area=@Cd_Area
		END
	ELSE
		INSERT
			Dep_Acesso
			(
				Cd_Area,Cd_tela,leitura, gravacao, exclusao
			)
		Values
			(
				@Cd_Area, @cd_tela, @leitura, @gravacao, @exclusao
			)
	

Commit Transaction

GO
