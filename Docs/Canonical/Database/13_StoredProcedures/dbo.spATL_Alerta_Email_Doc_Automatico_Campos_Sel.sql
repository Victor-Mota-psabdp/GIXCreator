SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Alerta_Email_Doc_Automatico_Campos
CREATE procedure [dbo].[spATL_Alerta_Email_Doc_Automatico_Campos_Sel]--null,'Teste','Z'
(
	@ID	BIGINT,
	@Nome_Campo varchar(50),
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
			ID				[Code],
			Nome_Campo		[Field Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Alerta_Email_Doc_Automatico_Campos T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select 
			ID		[Code],
			Nome_Campo		[Field Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Alerta_Email_Doc_Automatico_Campos T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ativo = 1
	End

if @Tipo = 'C'
	Begin
		select 
			ID		[Code],
			Nome_Campo		[Field Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Alerta_Email_Doc_Automatico_Campos T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ID = @ID and
			ativo = 1
	End
	
if @Tipo = 'D'
	Begin
		select 
			ID		[Code],
			Nome_Campo		[Field Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Alerta_Email_Doc_Automatico_Campos T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ID = @ID and
			ativo = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			ID		[Code],
			Nome_Campo		[Field Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Alerta_Email_Doc_Automatico_Campos T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Nome_Campo = @Nome_Campo
	End
	
if @Tipo = 'O'
	Begin
		select 
			ID		[Code],
			Nome_Campo		[Field Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Alerta_Email_Doc_Automatico_Campos T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Nome_Campo = @Nome_Campo and
			ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			ID		[Code],
			Nome_Campo		[Field Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]
		from Alerta_Email_Doc_Automatico_Campos T with(nolock)
			left join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Nome_Campo = @Nome_Campo
			AND ID <> isnull(@ID,0)
	End

GO
