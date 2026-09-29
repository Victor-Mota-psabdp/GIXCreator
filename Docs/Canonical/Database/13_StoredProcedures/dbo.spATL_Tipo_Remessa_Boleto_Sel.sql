SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Remessa_Boleto
CREATE procedure [dbo].[spATL_Tipo_Remessa_Boleto_Sel]--null,'Teste','Z'
(
	@Id_Tp_Remessa	BIGINT,
	@Nome_Tp_Remessa varchar(MAX),
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
			Id_Tp_Remessa		[Code],
			Nome_Tp_Remessa		[Remessa Type Name],
			Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			dt_ins				[Insert Date]
		from Tipo_Remessa_Boleto T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
	End
	
if  @Tipo = 'B'
	Begin
		select 
			Id_Tp_Remessa		[Code],
			Nome_Tp_Remessa		[Remessa Type Name],
			Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			dt_ins				[Insert Date]
		from Tipo_Remessa_Boleto T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			ativo = 1
	End

if @Tipo = 'C'
	Begin
		select 
			Id_Tp_Remessa		[Code],
			Nome_Tp_Remessa		[Remessa Type Name],
			Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			dt_ins				[Insert Date]
		from Tipo_Remessa_Boleto T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Id_Tp_Remessa = @Id_Tp_Remessa
	End
	
if @Tipo = 'D'
	Begin
		select 
			Id_Tp_Remessa		[Code],
			Nome_Tp_Remessa		[Remessa Type Name],
			Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			dt_ins				[Insert Date]
		from Tipo_Remessa_Boleto T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Id_Tp_Remessa = @Id_Tp_Remessa and
			ativo = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			Id_Tp_Remessa		[Code],
			Nome_Tp_Remessa		[Remessa Type Name],
			Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			dt_ins				[Insert Date]
		from Tipo_Remessa_Boleto T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Nome_Tp_Remessa = @Nome_Tp_Remessa
	End
	
if @Tipo = 'O'
	Begin
		select 
			Id_Tp_Remessa		[Code],
			Nome_Tp_Remessa		[Remessa Type Name],
			Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			dt_ins				[Insert Date]
		from Tipo_Remessa_Boleto T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Nome_Tp_Remessa = @Nome_Tp_Remessa and
			ativo = 1
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			Id_Tp_Remessa		[Code],
			Nome_Tp_Remessa		[Remessa Type Name],
			Ativo				[Enabled],
			T.Cd_Usuario		[User Code],
			U.Nome_Usuario		[User Name],
			dt_ins				[Insert Date]
		from Tipo_Remessa_Boleto T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
		where
			Nome_Tp_Remessa = @Nome_Tp_Remessa
			AND Id_Tp_Remessa <> isnull(@Id_Tp_Remessa,0)
	End

GO
