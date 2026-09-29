SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_System_Code
CREATE procedure [dbo].[spATL_Tipo_System_Code_Sel]--null,'Teste','Z'
(
	@ID_System_Code		BIGINT,
	@Name_System_Code	VARCHAR(100),
	@Tipo				char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' 
	Begin
		select 
			T.ID_System_Code		[Code],
			T.Name_System_Code	[System Code Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]
		from ATL_INT.dbo.Tipo_System_Code T with(nolock)
			join ATLANTIS.dbo.Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select 
			T.ID_System_Code		[Code],
			T.Name_System_Code	[System Code Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]
		from ATL_INT.dbo.Tipo_System_Code T with(nolock)
			join ATLANTIS.dbo.Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.ativo = 1
	End

if @Tipo = 'C'
	Begin
		select 
			T.ID_System_Code		[Code],
			T.Name_System_Code	[System Code Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]
		from ATL_INT.dbo.Tipo_System_Code T with(nolock)
			join ATLANTIS.dbo.Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.ID_System_Code = @ID_System_Code and
			T.ativo = 1
	End
	
if @Tipo = 'D'
	Begin
	select 
			T.ID_System_Code		[Code],
			T.Name_System_Code	[System Code Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]
		from ATL_INT.dbo.Tipo_System_Code T with(nolock)
			join ATLANTIS.dbo.Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.ID_System_Code = @ID_System_Code and
			T.ativo = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			T.ID_System_Code		[Code],
			T.Name_System_Code	[System Code Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]
		from ATL_INT.dbo.Tipo_System_Code T with(nolock)
			join ATLANTIS.dbo.Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.Name_System_Code = @Name_System_Code
	End
	
if @Tipo = 'O'
	Begin
		select 
			T.ID_System_Code		[Code],
			T.Name_System_Code	[System Code Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]
		from ATL_INT.dbo.Tipo_System_Code T with(nolock)
			join ATLANTIS.dbo.Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.Name_System_Code = @Name_System_Code and
			T.ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			T.ID_System_Code		[Code],
			T.Name_System_Code	[System Code Name],
			T.Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			T.dt_ins			[Insert Date]
		from ATL_INT.dbo.Tipo_System_Code T with(nolock)
			join ATLANTIS.dbo.Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.Name_System_Code = @Name_System_Code
			AND T.ID_System_Code <> isnull(@ID_System_Code,0)
	End

GO
