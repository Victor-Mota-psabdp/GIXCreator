SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_DC
CREATE procedure [dbo].[spATL_Tipo_DC_Sel]--null,'Teste','Z'
(
	@Cd_Tp_DC		varchar(1),
	@Descricao_TP_DC		varchar(50),
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
			Cd_Tp_DC		[Code],
			Descricao_TP_DC		[DC Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_DC T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select 
			Cd_Tp_DC		[Code],
			Descricao_TP_DC		[DC Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_DC T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ativo = 1
	End

if @Tipo = 'C'
	Begin
	select 
			Cd_Tp_DC		[Code],
			Descricao_TP_DC		[DC Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_DC T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Cd_Tp_DC = @Cd_Tp_DC and
			ativo = 1
	End
	
if @Tipo = 'D'
	Begin
		select 
			Cd_Tp_DC		[Code],
			Descricao_TP_DC		[DC Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_DC T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Cd_Tp_DC = @Cd_Tp_DC and
			ativo = 1
	End
	
if @Tipo = 'N'
	Begin
	select 
			Cd_Tp_DC		[Code],
			Descricao_TP_DC		[DC Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_DC T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Descricao_TP_DC = @Descricao_TP_DC
	End
	
if @Tipo = 'O'
	Begin
		select 
			Cd_Tp_DC		[Code],
			Descricao_TP_DC		[DC Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_DC T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Descricao_TP_DC = @Descricao_TP_DC and
			ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Cd_Tp_DC		[Code],
			Descricao_TP_DC		[DC Type Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Tipo_DC T with(nolock)
			LEFT join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Descricao_TP_DC = @Descricao_TP_DC
			AND Cd_Tp_DC <> isnull(@Cd_Tp_DC,0)
	End

GO
