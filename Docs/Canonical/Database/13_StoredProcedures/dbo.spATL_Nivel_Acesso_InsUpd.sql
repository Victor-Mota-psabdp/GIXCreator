SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Nivel_Acesso
CREATE PROCEDURE [dbo].[spATL_Nivel_Acesso_InsUpd]
(	
	@Cd_Area		varchar(3),
	--@Nome_Area		varchar(30),
	@Cd_Tela		varchar(3),
	--@Nome_Tela		varchar(50),
	@Cd_Nivel		varchar(3),
	--@Tipo_Nivel		varchar(30),	
	@Leitura		char(1),
	@Gravacao		char(1),
	@Exclusao		char(1)
)


AS

Begin Transaction

	----sp_help Area
	--Declare @Cd_Area		varchar(6)
	--set @Cd_Area = (Select Cd_Area from Area where Nome_Area = @Nome_Area)
	
	----sp_help Tela_ATL
	--Declare @Cd_Tela	varchar(3)
	--set @Cd_Tela = (Select Cd_Tela from Tela_ATL where Nome_Tela = @Nome_Tela)	
	
	----sp_help Nivel
	--Declare @Cd_Nivel	varchar(6)
	--set @Cd_Nivel = (Select Cd_Nivel from Nivel where Tipo_Nivel = @Tipo_Nivel)
	--if @Cd_Nivel is null
	--set @Cd_Nivel = '%'
	
	IF  exists(SELECT Cd_Area FROM Nivel_Acesso WHERE 
		Cd_tela=@cd_tela AND Cd_Area=@Cd_Area and Cd_Nivel = @Cd_Nivel)
		BEGIN
			UPDATE
				Nivel_Acesso
			SET			
				leitura = @leitura,
				gravacao = @gravacao,
				exclusao = @exclusao
			WHERE
				Cd_tela=@cd_tela and
				Cd_Area=@Cd_Area and 
				Cd_Nivel = @Cd_Nivel
		END
	ELSE
		INSERT
			Nivel_Acesso
			(
				Cd_Area,Cd_tela,Cd_Nivel,Leitura, gravacao, exclusao
			)
		Values
			(
				@Cd_Area, @cd_tela,@Cd_Nivel,@leitura, @gravacao, @exclusao
			)
	

Commit Transaction

GO
