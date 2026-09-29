SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  procedure [dbo].[spUsuario_InsUpd]

	@cdUsuario		varchar(15),
	@Nome			varchar(30),
	@Senha			varchar(20),
	@cdArea			char(3),
	@Cargo			varchar(20),
	@Idioma			char(3),
	@Grupo			varchar(10),
	@Email			varchar(40),
	@ck				bit,
	@fone			varchar(18),
	@Nivel			varchar(50)

AS



Begin Transaction

	Declare @Cd_Nivel varchar(3)

	set @Cd_Nivel = (Select Cd_Nivel from Nivel where Tipo_Nivel = @Nivel)

	If  exists (select cd_usuario from Usuario where Cd_Usuario=@cdUsuario)
	Begin
		Update
			Usuario
		Set
			Nome_Usuario = @Nome,
			Senha = @Senha,
			Cd_Area =@cdArea,
			Cargo=@Cargo,
			Cd_Idioma=@Idioma,
			Grupo = @Grupo,
			Email=@Email,
			Ck_Ativo=@ck,
			Fone=@fone,
			cd_Nivel = @cd_Nivel
		Where
			cd_usuario=@CdUsuario
	End
	Else
		Insert
			Usuario(
				Cd_Usuario,
				Nome_Usuario,
				Senha,
				Cd_Area,
				Cargo,
				Cd_Idioma,
				Grupo,
				Email,
				Ck_Ativo,
				Fone,
				Cd_Nivel
				)
		Values
			(
				@cdUsuario,
				@Nome,
				@Senha,
				@cdArea,
				@Cargo,
				@Idioma,
				@Grupo,
				@Email,
				@ck,
				@fone,
				@Cd_Nivel
			)
	

Commit Transaction






GO
