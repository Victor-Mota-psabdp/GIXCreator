SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Usuario_Grupo_Acesso
CREATE procedure [dbo].[spATL_Usuario_Grupo_Acesso_Sel]--null,'Teste','Z'
(
	@Cd_Pes_Grupo		VARCHAR(10),
	@Cd_Usuario_Grupo	VARCHAR(6),
	@Tipo char(1)
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
			ID						[Code],
			T.cd_pes_grupo			[Group Code],
			P.Apelido				[Group Name],
			T.Cd_Usuario_Grupo		[User Group Code],
			UG.Nome_Usuario   [User Group Name], 		
			Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			dt_ins					[Insert Date]
		from Usuario_Grupo_Acesso T with(nolock)
			join Usuario UG with(nolock) on UG.Cd_Usuario=T.Cd_Usuario_Grupo
			join Pessoa P with(nolock) on P.Cd_Pes = T.cd_pes_grupo
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select 
			ID						[Code],
			T.cd_pes_grupo			[Group Code],
			P.Apelido				[Group Name],
			T.Cd_Usuario_Grupo		[User Group Code],
			UG.Nome_Usuario   [User Group Name], 
			Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			dt_ins					[Insert Date]
		from Usuario_Grupo_Acesso T with(nolock)
			join Usuario UG with(nolock) on UG.Cd_Usuario=T.Cd_Usuario_Grupo
			join Pessoa P with(nolock) on P.Cd_Pes = T.cd_pes_grupo
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ativo = 1
	End

if @Tipo = 'C'
	Begin
		select 
			ID						[Code],
			T.cd_pes_grupo			[Group Code],
			P.Apelido				[Group Name],
			T.Cd_Usuario_Grupo		[User Group Code],
			UG.Nome_Usuario   [User Group Name], 
			Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			dt_ins					[Insert Date]
		from Usuario_Grupo_Acesso T with(nolock)
			join Usuario UG with(nolock) on UG.Cd_Usuario=T.Cd_Usuario_Grupo
			join Pessoa P with(nolock) on P.Cd_Pes = T.cd_pes_grupo
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.Cd_Pes_Grupo = @Cd_Pes_Grupo
	End
	
if @Tipo = 'D'
	Begin
		select 
			ID						[Code],
			T.cd_pes_grupo			[Group Code],
			P.Apelido				[Group Name],
			T.Cd_Usuario_Grupo		[User Group Code],
			UG.Nome_Usuario   [User Group Name], 
			Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			dt_ins					[Insert Date]
		from Usuario_Grupo_Acesso T with(nolock)
			join Usuario UG with(nolock) on UG.Cd_Usuario=T.Cd_Usuario_Grupo
			join Pessoa P with(nolock) on P.Cd_Pes = T.cd_pes_grupo
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			T.Cd_Pes_Grupo = @Cd_Pes_Grupo and
			ativo = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			ID						[Code],
			T.cd_pes_grupo			[Group Code],
			P.Apelido				[Group Name],
			T.Cd_Usuario_Grupo		[User Group Code],
			UG.Nome_Usuario   [User Group Name], 
			Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			dt_ins					[Insert Date]
		from Usuario_Grupo_Acesso T with(nolock)
			join Usuario UG with(nolock) on UG.Cd_Usuario=T.Cd_Usuario_Grupo
			join Pessoa P with(nolock) on P.Cd_Pes = T.cd_pes_grupo
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Cd_Usuario_Grupo= @Cd_Usuario_Grupo
	End
	
if @Tipo = 'O'
	Begin
		select 
			ID						[Code],
			T.cd_pes_grupo			[Group Code],
			P.Apelido				[Group Name],
			T.Cd_Usuario_Grupo		[User Group Code],
			UG.Nome_Usuario   [User Group Name], 
			Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			dt_ins					[Insert Date]
		from Usuario_Grupo_Acesso T with(nolock)
			join Usuario UG with(nolock) on UG.Cd_Usuario=T.Cd_Usuario_Grupo
			join Pessoa P with(nolock) on P.Cd_Pes = T.cd_pes_grupo
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Cd_Usuario_Grupo= @Cd_Usuario_Grupo and
			ativo = 1
	End
	
if @Tipo = 'P' 
	Begin
		select 
			ID						[Code],
			T.cd_pes_grupo			[Group Code],
			P.Apelido				[Group Name],
			T.Cd_Usuario_Grupo		[User Group Code],
			UG.Nome_Usuario   [User Group Name], 
			Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			dt_ins					[Insert Date]
		from Usuario_Grupo_Acesso T with(nolock)
			join Usuario UG with(nolock) on UG.Cd_Usuario=T.Cd_Usuario_Grupo
			join Pessoa P with(nolock) on P.Cd_Pes = T.cd_pes_grupo
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Cd_Usuario_Grupo= @Cd_Usuario_Grupo
			AND T.Cd_Pes_Grupo = @Cd_Pes_Grupo
	End
if @Tipo = 'P' --or @Tipo = 'O'
	Begin
		select 
			ID						[Code],
			T.cd_pes_grupo			[Group Code],
			P.Apelido				[Group Name],
			T.Cd_Usuario_Grupo		[User Group Code],
			UG.Nome_Usuario   [User Group Name], 
			Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			dt_ins					[Insert Date]
		from Usuario_Grupo_Acesso T with(nolock)
			join Usuario UG with(nolock) on UG.Cd_Usuario=T.Cd_Usuario_Grupo
			join Pessoa P with(nolock) on P.Cd_Pes = T.cd_pes_grupo
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Cd_Usuario_Grupo= @Cd_Usuario_Grupo
			AND T.Cd_Pes_Grupo = @Cd_Pes_Grupo
			AND	Ativo = 1
	End
GO
