SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Acordo_Comercial
CREATE procedure [dbo].[spATL_Tipo_Acordo_Comercial_Sel]--null,'Teste','Z'
(
	@ID_TP_AC	BIGINT,
	@NOME_TP_AC varchar(MAX),
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
			ID_TP_AC		[Code],
			NOME_TP_AC		[Agreement Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]			
			--NOME_TP_AC [Nome Acordo],Ativo,Nome_Usuario,dt_ins [Data]
		from Tipo_Acordo_Comercial T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select 
			ID_TP_AC		[Code],
			NOME_TP_AC		[Agreement Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]			
			--NOME_TP_AC [Nome Acordo],Ativo,Nome_Usuario,dt_ins [Data]
		from Tipo_Acordo_Comercial T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ativo = 1
	End

if @Tipo = 'C'
	Begin
		select 
			ID_TP_AC		[Code],
			NOME_TP_AC		[Agreement Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]			
			--NOME_TP_AC [Nome Acordo],Ativo,Nome_Usuario,dt_ins [Data] 
		from Tipo_Acordo_Comercial T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ID_TP_AC = @ID_TP_AC and
			ativo = 1
	End
	
if @Tipo = 'D'
	Begin
		select 
			ID_TP_AC		[Code],
			NOME_TP_AC		[Agreement Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]			
			--NOME_TP_AC [Nome Acordo],Ativo,Nome_Usuario,dt_ins [Data]
		from Tipo_Acordo_Comercial T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ID_TP_AC = @ID_TP_AC and
			ativo = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			ID_TP_AC		[Code],
			NOME_TP_AC		[Agreement Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]			
			--NOME_TP_AC [Nome Acordo],Ativo,Nome_Usuario,dt_ins [Data]
		from Tipo_Acordo_Comercial T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			NOME_TP_AC = @NOME_TP_AC
	End
	
if @Tipo = 'O'
	Begin
		select 
			ID_TP_AC		[Code],
			NOME_TP_AC		[Agreement Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]			
			--NOME_TP_AC [Nome Acordo],Ativo,Nome_Usuario,dt_ins [Data]
		from Tipo_Acordo_Comercial T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			NOME_TP_AC = @NOME_TP_AC and
			ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			ID_TP_AC		[Code],
			NOME_TP_AC		[Agreement Name],
			Ativo			[Enabled],
			T.Cd_Usuario	[User Code],
			U.Nome_Usuario	[User Name],
			dt_ins			[Insert Date]			
			--NOME_TP_AC [Nome Acordo],Ativo,Nome_Usuario,dt_ins [Data]
		from Tipo_Acordo_Comercial T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			NOME_TP_AC = @NOME_TP_AC
			AND ID_TP_AC <> isnull(@ID_TP_AC,0)
	End

GO
