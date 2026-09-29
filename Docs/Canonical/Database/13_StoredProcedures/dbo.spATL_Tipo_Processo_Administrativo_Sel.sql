SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Processo_Administrativo
CREATE procedure [dbo].[spATL_Tipo_Processo_Administrativo_Sel]
(
	@Id_Tp_Proc_Adm		BigInt,
    @Nome_Tp_Proc_Adm	varchar(MAX), 
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
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A' 
	Begin
		select Id_Tp_Proc_Adm AS Code,Nome_Tp_Proc_Adm AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Processo_Administrativo DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario		
	End
if @Tipo = 'B'
	Begin
		select 
			Id_Tp_Proc_Adm AS Code,Nome_Tp_Proc_Adm AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Processo_Administrativo DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
	End
	
if @Tipo = 'C' 
	Begin
		select 
			Id_Tp_Proc_Adm AS Code,Nome_Tp_Proc_Adm AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Processo_Administrativo DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			Id_Tp_Proc_Adm = @Id_Tp_Proc_Adm
	End
	
if @Tipo = 'D'
	Begin
		select 
			Id_Tp_Proc_Adm AS Code,Nome_Tp_Proc_Adm AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Processo_Administrativo DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
			and Id_Tp_Proc_Adm = @Id_Tp_Proc_Adm
	End
	
if @Tipo = 'N' 
	Begin
		select 
			Id_Tp_Proc_Adm AS Code,Nome_Tp_Proc_Adm AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Processo_Administrativo DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			Nome_Tp_Proc_Adm = @Nome_Tp_Proc_Adm
	End
	
if  @Tipo = 'O'
	Begin
		select 
			Id_Tp_Proc_Adm AS Code,Nome_Tp_Proc_Adm AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Processo_Administrativo DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
			and Nome_Tp_Proc_Adm = @Nome_Tp_Proc_Adm
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select Id_Tp_Proc_Adm AS Code,Nome_Tp_Proc_Adm AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Processo_Administrativo DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			Nome_Tp_Proc_Adm = @Nome_Tp_Proc_Adm 
			and Id_Tp_Proc_Adm <> @Id_Tp_Proc_Adm

	End

GO
