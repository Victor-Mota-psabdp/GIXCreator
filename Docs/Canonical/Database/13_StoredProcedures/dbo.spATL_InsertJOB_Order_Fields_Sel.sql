SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_InsertJOB_Order_Fields_Sel]--null,'Teste','Z'
(
	@Id							int,
	@Cd_Pes_Grupo				varchar(10),
	@Modal						varchar(2),	
	@Tipo						char(1)
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
			T.Id							[Id],
			T.Modal							[Modal Code],
			TM.Nome_TP_MODAL				[Modal Name],
			T.Cd_Pes_Grupo					[Group Code],
			P.Apelido						[Group Name],
			T.Incoterm						[Incoterm],
			T.Currency						[Currency],
			T.Order_Value					[Order Value],
			T.Status						[Enabled],
			T.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			T.Dt_Ins						[Insert Date]
		from InsertJOB_Order_Fields T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			Join Tipo_Modal_Imp_Exp		TM	With(nolock) on T.Modal = TM.CD_TP_MODAL
			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
	End
	
--if  @Tipo = 'B'
--	Begin
--		select 
--			T.Id_Integration_Received		[Code],
--			T.Name_Integration_Received		[Integration Received Name],
--			T.Cd_Pes_Grupo					[Group Code],
--			P.Apelido						[Group Name],
--			T.Status						[Enabled],
--			T.Cd_Usuario					[User Code],
--			U.Nome_Usuario					[User Name],
--			T.Dt_Ins						[Insert Date]
--		from Type_Integration_Received T with(nolock)
--			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
--			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
--		where
--			T.Status = 1
--	End

if @Tipo = 'C'
Begin
select 
			T.Id							[Id],
			T.Modal							[Modal Code],
			TM.Nome_TP_MODAL				[Modal Name],
			T.Cd_Pes_Grupo					[Group Code],
			P.Apelido						[Group Name],
			T.Incoterm						[Incoterm],
			T.Currency						[Currency],
			T.Order_Value					[Order Value],
			T.Status						[Enabled],
			T.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			T.Dt_Ins						[Insert Date]
		from InsertJOB_Order_Fields T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			Join Tipo_Modal_Imp_Exp		TM	With(nolock) on T.Modal = TM.CD_TP_MODAL
			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
		where
			T.Id = @Id
	End
	
--if @Tipo = 'D'
--	Begin
--		select 
--			T.Id_Integration_Received		[Code],
--			T.Name_Integration_Received		[Integration Received Name],
--			T.Cd_Pes_Grupo					[Group Code],
--			P.Apelido						[Group Name],
--			T.Status						[Enabled],
--			T.Cd_Usuario					[User Code],
--			U.Nome_Usuario					[User Name],
--			T.Dt_Ins						[Insert Date]
--		from Type_Integration_Received T with(nolock)
--			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
--			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
--		where
--			T.Id_Integration_Received = @Id_Integration_Received and
--			T.Status = 1
--	End
	
--if @Tipo = 'N'
--	Begin
--		select 
--			T.Id_Integration_Received		[Code],
--			T.Name_Integration_Received		[Integration Received Name],
--			T.Cd_Pes_Grupo					[Group Code],
--			P.Apelido						[Group Name],
--			T.Status						[Enabled],
--			T.Cd_Usuario					[User Code],
--			U.Nome_Usuario					[User Name],
--			T.Dt_Ins						[Insert Date]
--		from Type_Integration_Received T with(nolock)
--			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
--			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
--		where
--			T.Name_Integration_Received  = @Name_Integration_Received 
--	End
	
--if @Tipo = 'O'
--	Begin
--		select 
--			T.Id_Integration_Received		[Code],
--			T.Name_Integration_Received		[Integration Received Name],
--			T.Cd_Pes_Grupo					[Group Code],
--			P.Apelido						[Group Name],
--			T.Status						[Enabled],
--			T.Cd_Usuario					[User Code],
--			U.Nome_Usuario					[User Name],
--			T.Dt_Ins						[Insert Date]
--		from Type_Integration_Received T with(nolock)
--			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
--			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
--		where
--			T.Name_Integration_Received  = @Name_Integration_Received  and
--			Status = 1
--	End

--if @Tipo = 'P'
--	Begin
--		select 
--			T.Id_Integration_Received		[Code],
--			T.Name_Integration_Received		[Integration Received Name],
--			T.Cd_Pes_Grupo					[Group Code],
--			P.Apelido						[Group Name],
--			T.Status						[Enabled],
--			T.Cd_Usuario					[User Code],
--			U.Nome_Usuario					[User Name],
--			T.Dt_Ins						[Insert Date]
--		from Type_Integration_Received T with(nolock)
--			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
--			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
--		where
--			T.Id_Integration_Received = @Id_Integration_Received and
--			T.Cd_Pes_Grupo  = @Cd_Pes_Grupo
--	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			T.Id							[Id],
			T.Modal							[Modal Code],
			TM.Nome_TP_MODAL				[Modal Name],
			T.Cd_Pes_Grupo					[Group Code],
			P.Apelido						[Group Name],
			T.Incoterm						[Incoterm],
			T.Currency						[Currency],
			T.Order_Value					[Order Value],
			T.Status						[Enabled],
			T.Cd_Usuario					[User Code],
			U.Nome_Usuario					[User Name],
			T.Dt_Ins						[Insert Date]
		from InsertJOB_Order_Fields T with(nolock)
			join Usuario U with(nolock) on U.Cd_Usuario=T.Cd_Usuario
			Join Tipo_Modal_Imp_Exp		TM	With(nolock) on T.Modal = TM.CD_TP_MODAL
			join Pessoa P with(nolock) on P.Cd_Pes=T.Cd_Pes_Grupo
		where
			T.Modal = @Modal
			AND T.Cd_Pes_Grupo  = @Cd_Pes_Grupo 
			AND T.Id <> isnull(@Id,0)
	End

GO
