SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Banco
CREATE procedure [dbo].[spATL_Tipo_Banco_Sel]--null,'Teste','Z'
(
	@id_tp_banco	BIGINT,
	@nome_tp_banco	varchar(50),
	@Tipo			char(1)
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
			T.id_tp_banco			[Code],
			T.nome_tp_banco			[Bank Type Name],
			T.Nome_full_banco		[Bank Type Complete Name],
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Banco T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select 
			T.id_tp_banco			[Code],
			T.nome_tp_banco			[Bank Type Name],
			T.Nome_full_banco		[Bank Type Complete Name],
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Banco T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ativo = 1
	End

if @Tipo = 'C'
	Begin
		select 
			T.id_tp_banco			[Code],
			T.nome_tp_banco			[Bank Type Name],
			T.Nome_full_banco		[Bank Type Complete Name],
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Banco T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			id_tp_banco = @id_tp_banco and
			ativo = 1
	End
	
if @Tipo = 'D'
	Begin
		select 
			T.id_tp_banco			[Code],
			T.nome_tp_banco			[Bank Type Name],
			T.Nome_full_banco		[Bank Type Complete Name],
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Banco T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			id_tp_banco = @id_tp_banco and
			ativo = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			T.id_tp_banco			[Code],
			T.nome_tp_banco			[Bank Type Name],
			T.Nome_full_banco		[Bank Type Complete Name],
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Banco T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			nome_tp_banco = @nome_tp_banco
	End
	
if @Tipo = 'O'
	Begin
		select 
			T.id_tp_banco			[Code],
			T.nome_tp_banco			[Bank Type Name],
			T.Nome_full_banco		[Bank Type Complete Name],
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Banco T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			nome_tp_banco = @nome_tp_banco and
			ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			T.id_tp_banco			[Code],
			T.nome_tp_banco			[Bank Type Name],
			T.Nome_full_banco		[Bank Type Complete Name],
			T.Ativo					[Enabled],
			T.Cd_Usuario			[User Code],
			U.Nome_Usuario			[User Name],
			T.dt_ins				[Insert Date]	
		from Tipo_Banco T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			nome_tp_banco = @nome_tp_banco
			AND id_tp_banco <> isnull(@id_tp_banco,0)
	End

GO
