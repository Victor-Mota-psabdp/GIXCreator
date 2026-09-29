SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Type_Doc_Received_By_Email_Rules_Sel]
(
	@Cd_Tipo		varchar(1),
    @Nome_Tipo		varchar(200), 
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
		select Cd_Tipo AS Code,Nome_Tipo AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DI with(nolock)
		left join atlantis.dbo.Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario		
	End
if @Tipo = 'B'
	Begin
		select Cd_Tipo AS Code,Nome_Tipo AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DI with(nolock)
		left join atlantis.dbo.Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
	End
	
if @Tipo = 'C' 
	Begin
		select Cd_Tipo AS Code,Nome_Tipo AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DI with(nolock)
		left join atlantis.dbo.Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			Cd_Tipo = @Cd_Tipo
	End
	
if @Tipo = 'D'
	Begin
		select Cd_Tipo AS Code,Nome_Tipo AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DI with(nolock)
		left join atlantis.dbo.Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
			and Cd_Tipo = @Cd_Tipo
	End
	
if @Tipo = 'N' 
	Begin
		select Cd_Tipo AS Code,Nome_Tipo AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DI with(nolock)
		left join atlantis.dbo.Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			Nome_Tipo = @Nome_Tipo
	End
	
if  @Tipo = 'O'
	Begin
		select Cd_Tipo AS Code,Nome_Tipo AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DI with(nolock)
		left join atlantis.dbo.Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario

		where
			ativo = 1
			and Nome_Tipo = @Nome_Tipo
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select Cd_Tipo AS Code,Nome_Tipo AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from ATL_INT.[dbo].Type_Doc_Received_By_Email_Rules DI with(nolock)
		left join atlantis.dbo.Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			Nome_Tipo = @Nome_Tipo 
			and Cd_Tipo <> @Cd_Tipo

	End

GO
