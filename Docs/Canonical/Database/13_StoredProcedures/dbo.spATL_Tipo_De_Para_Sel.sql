SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_De_Para
CREATE procedure [dbo].[spATL_Tipo_De_Para_Sel]--null,'Teste','Z'
(
	@Cd_Tipo		int,
	@NOME_Tipo		varchar(100),
	@Tipo			 char(1)
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
			Cd_Tipo			[Code],
			NOME_Tipo		[Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_De_Para T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select 
			Cd_Tipo		[Code],
			NOME_Tipo		[Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_De_Para T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ativo = 1
	End

if @Tipo = 'C'
	Begin
	select 
			Cd_Tipo		[Code],
			NOME_Tipo		[Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_De_Para T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Cd_Tipo = @Cd_Tipo and
			ativo = 1
	End
	
if @Tipo = 'D'
	Begin
		select 
			Cd_Tipo		[Code],
			NOME_Tipo		[Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_De_Para T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Cd_Tipo = @Cd_Tipo and
			ativo = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			Cd_Tipo		[Code],
			NOME_Tipo		[Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_De_Para T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			NOME_Tipo = @NOME_Tipo
	End
	
if @Tipo = 'O'
	Begin
		select 
			Cd_Tipo		[Code],
			NOME_Tipo		[Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_De_Para T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			NOME_Tipo = @NOME_Tipo and
			ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Tipo		[Code],
			NOME_Tipo		[Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_De_Para T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			NOME_Tipo = @NOME_Tipo
			AND Cd_Tipo <> isnull(@Cd_Tipo,0)
	End

GO
