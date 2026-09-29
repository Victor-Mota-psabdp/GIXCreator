SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Type_Integration_Received
CREATE procedure [dbo].[spATL_Type_Integration_Received_Sel]--null,'Teste','Z'
(
	@Id_Integration_Received	BIGINT,
	@Name_Integration_Received  varchar(150),
	@Cd_Pes_Grupo				varchar(10),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Statuss
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Statuss
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Statuss
*/

if @Tipo = 'A' 
	Begin
		select 
			T.Id_Integration_Received		[Code],
			T.Name_Integration_Received		[Integration Received Name],
			T.Cd_Pes_Grupo					[Group Code],
			P.Apelido						[Group Name],
			T.Status						[Enabled],
			T.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			T.Dt_Ins						[Insert Date]
		from Type_Integration_Received T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
	End
	
if  @Tipo = 'B'
	Begin
		select 
			T.Id_Integration_Received		[Code],
			T.Name_Integration_Received		[Integration Received Name],
			T.Cd_Pes_Grupo					[Group Code],
			P.Apelido						[Group Name],
			T.Status						[Enabled],
			T.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			T.Dt_Ins						[Insert Date]
		from Type_Integration_Received T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
		where
			T.Status = 1
	End

if @Tipo = 'C'
	Begin
		select 
			T.Id_Integration_Received		[Code],
			T.Name_Integration_Received		[Integration Received Name],
			T.Cd_Pes_Grupo					[Group Code],
			P.Apelido						[Group Name],
			T.Status						[Enabled],
			T.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			T.Dt_Ins						[Insert Date]
		from Type_Integration_Received T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
		where
			T.Id_Integration_Received = @Id_Integration_Received
	End
	
if @Tipo = 'D'
	Begin
		select 
			T.Id_Integration_Received		[Code],
			T.Name_Integration_Received		[Integration Received Name],
			T.Cd_Pes_Grupo					[Group Code],
			P.Apelido						[Group Name],
			T.Status						[Enabled],
			T.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			T.Dt_Ins						[Insert Date]
		from Type_Integration_Received T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
		where
			T.Id_Integration_Received = @Id_Integration_Received and
			T.Status = 1
	End
	
if @Tipo = 'N'
	Begin
		select 
			T.Id_Integration_Received		[Code],
			T.Name_Integration_Received		[Integration Received Name],
			T.Cd_Pes_Grupo					[Group Code],
			P.Apelido						[Group Name],
			T.Status						[Enabled],
			T.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			T.Dt_Ins						[Insert Date]
		from Type_Integration_Received T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
		where
			T.Name_Integration_Received  = @Name_Integration_Received 
	End
	
if @Tipo = 'O'
	Begin
		select 
			T.Id_Integration_Received		[Code],
			T.Name_Integration_Received		[Integration Received Name],
			T.Cd_Pes_Grupo					[Group Code],
			P.Apelido						[Group Name],
			T.Status						[Enabled],
			T.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			T.Dt_Ins						[Insert Date]
		from Type_Integration_Received T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
		where
			T.Name_Integration_Received  = @Name_Integration_Received  and
			Status = 1
	End

if @Tipo = 'P'
	Begin
		select 
			T.Id_Integration_Received		[Code],
			T.Name_Integration_Received		[Integration Received Name],
			T.Cd_Pes_Grupo					[Group Code],
			P.Apelido						[Group Name],
			T.Status						[Enabled],
			T.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			T.Dt_Ins						[Insert Date]
		from Type_Integration_Received T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
		where
			T.Id_Integration_Received = @Id_Integration_Received and
			T.Cd_Pes_Grupo  = @Cd_Pes_Grupo
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			T.Id_Integration_Received		[Code],
			T.Name_Integration_Received		[Integration Received Name],
			T.Cd_Pes_Grupo					[Group Code],
			P.Apelido						[Group Name],
			T.Status						[Enabled],
			T.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			T.Dt_Ins						[Insert Date]
		from Type_Integration_Received T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
		where
			T.Name_Integration_Received  = @Name_Integration_Received 
			AND T.Id_Integration_Received <> isnull(@Id_Integration_Received,0)
	End

GO
