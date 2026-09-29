SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 -- Alessandra 11/06/2020 -@ADDomain e @ADUserName
CREATE  procedure [dbo].[spATLDN_Usuario_InsUpd]
(
	@Cd_Usuario		varchar(6),
	@Nome_Usuario	varchar(30),
	@Senha			varchar(20),
	@Cd_Area		varchar(3),
	@Cargo			varchar(20),
	@Cd_Idioma		varchar(3),
	@Email			varchar(40),
	@Grupo			varchar(10),
	@Ck_Ativo		bit,
	@Fone			varchar(18),
	@Cd_Nivel		varchar(3),
	@ADDomain		varchar(100),
	@ADUserName		varchar(40)
)
AS

Begin Transaction

	If exists (select cd_usuario from Usuario where Cd_Usuario=@Cd_Usuario)
		Begin
			Update
				Usuario
			Set
				Nome_Usuario	=	@Nome_Usuario,
				Senha			=	@Senha,
				Cd_Area			=	@Cd_Area,
				Cargo			=	@Cargo,
				Cd_Idioma		=	@Cd_Idioma,
				Grupo			=	@Grupo,
				Email			=	@Email,
				Ck_Ativo		=	@Ck_Ativo,
				Fone			=	@fone,
				cd_Nivel		=	@cd_Nivel,
				ADDomain		=	@ADDomain, 
				ADUserName		=	@ADUserName 
			Where
			cd_usuario=@Cd_Usuario
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
				Cd_Nivel,
				ADDomain, 
				ADUserName 
			)
		Values
			(
				@Cd_Usuario,
				@Nome_Usuario,
				@Senha,
				@Cd_Area,
				@Cargo,
				@Cd_Idioma,
				@Grupo,
				@Email,
				@Ck_Ativo,
				@fone,
				@Cd_Nivel,
				@ADDomain, 
				@ADUserName 
			)

Commit Transaction



/*ALTER  procedure [dbo].[spATLDN_Usuario_InsUpd]
(
	@Cd_Usuario		varchar(6),
	@Nome_Usuario	varchar(30),
	@Senha			varchar(20),
	@Nome_Area		varchar(30),
	@Cargo			varchar(20),
	@Nome_Idioma	varchar(30),
	@Email			varchar(40),
	@Grupo			varchar(10),
	@Ck_Ativo		bit,
	@Fone			varchar(18),
	@Tipo_Nivel		varchar(30),
	@ADDomain		varchar(100), -- Alessandra 11/06/2020
	@ADUserName		varchar(40) -- Alessandra 11/06/2020
)
AS

Begin Transaction

Declare @Cd_Nivel varchar(3)
set @Cd_Nivel = (Select Cd_Nivel from Nivel where Tipo_Nivel = @Tipo_Nivel)

Declare @Cd_Area varchar(3)
set @Cd_Area = (Select Cd_Area from Area where Nome_Area = @Nome_Area)

Declare @Cd_Idioma varchar(3)
set @Cd_Idioma = (Select Cd_Idioma from Idioma where Nome_Idioma = @Nome_Idioma)

	If exists (select cd_usuario from Usuario where Cd_Usuario=@Cd_Usuario)
		Begin
			Update
				Usuario
			Set
				Nome_Usuario	=	@Nome_Usuario,
				Senha			=	@Senha,
				Cd_Area			=	@Cd_Area,
				Cargo			=	@Cargo,
				Cd_Idioma		=	@Cd_Idioma,
				Grupo			=	@Grupo,
				Email			=	@Email,
				Ck_Ativo		=	@Ck_Ativo,
				Fone			=	@fone,
				cd_Nivel		=	@cd_Nivel,
				ADDomain		=	@ADDomain, -- Alessandra 11/06/2020
				ADUserName		=	@ADUserName -- Alessandra 11/06/2020
			Where
			cd_usuario=@Cd_Usuario
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
				Cd_Nivel,
				ADDomain, -- Alessandra 11/06/2020
				ADUserName -- Alessandra 11/06/2020
			)
		Values
			(
				@Cd_Usuario,
				@Nome_Usuario,
				@Senha,
				@Cd_Area,
				@Cargo,
				@Cd_Idioma,
				@Grupo,
				@Email,
				@Ck_Ativo,
				@fone,
				@Cd_Nivel,
				@ADDomain, -- Alessandra 11/06/2020
				@ADUserName -- Alessandra 11/06/2020
			)

Commit Transaction
*/

/*
ALTER  procedure [dbo].[spATLDN_Usuario_InsUpd]
(
	@Cd_Usuario		varchar(6),
	@Nome_Usuario	varchar(30),
	@Senha			varchar(20),
	@Nome_Area		varchar(30),
	@Cargo			varchar(20),
	@Nome_Idioma	varchar(30),
	@Email			varchar(40),
	@Grupo			varchar(10),
	@Ck_Ativo		bit,
	@Fone			varchar(18),
	@Tipo_Nivel		varchar(30),
	@ADDomain		varchar(100), -- Alessandra 11/06/2020
	@ADUserName		varchar(40) -- Alessandra 11/06/2020
)
AS

Begin Transaction

Declare @Cd_Nivel varchar(3)
set @Cd_Nivel = (Select Cd_Nivel from Nivel where Tipo_Nivel = @Tipo_Nivel)

Declare @Cd_Area varchar(3)
set @Cd_Area = (Select Cd_Area from Area where Nome_Area = @Nome_Area)

Declare @Cd_Idioma varchar(3)
set @Cd_Idioma = (Select Cd_Idioma from Idioma where Nome_Idioma = @Nome_Idioma)

	If exists (select cd_usuario from Usuario where Cd_Usuario=@Cd_Usuario)
		Begin
			Update
				Usuario
			Set
				Nome_Usuario	=	@Nome_Usuario,
				Senha			=	@Senha,
				Cd_Area			=	@Cd_Area,
				Cargo			=	@Cargo,
				Cd_Idioma		=	@Cd_Idioma,
				Grupo			=	@Grupo,
				Email			=	@Email,
				Ck_Ativo		=	@Ck_Ativo,
				Fone			=	@fone,
				cd_Nivel		=	@cd_Nivel,
				ADDomain		=	@ADDomain, -- Alessandra 11/06/2020
				ADUserName		=	@ADUserName -- Alessandra 11/06/2020
			Where
			cd_usuario=@Cd_Usuario
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
				Cd_Nivel,
				ADDomain, -- Alessandra 11/06/2020
				ADUserName -- Alessandra 11/06/2020
			)
		Values
			(
				@Cd_Usuario,
				@Nome_Usuario,
				@Senha,
				@Cd_Area,
				@Cargo,
				@Cd_Idioma,
				@Grupo,
				@Email,
				@Ck_Ativo,
				@fone,
				@Cd_Nivel,
				@ADDomain, -- Alessandra 11/06/2020
				@ADUserName -- Alessandra 11/06/2020
			)

Commit Transaction

*/
GO
