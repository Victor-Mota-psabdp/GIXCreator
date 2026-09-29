SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Status_Retificacao
CREATE procedure [dbo].[spATL_Tipo_Status_Retificacao_Sel]
(
	@ID_Status		BigInt,
    @Status_Descricao	varchar(50), 
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
		select ID_Status AS Code,Status_Descricao AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Status_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario		
	End
if @Tipo = 'B'
	Begin
		select 
			ID_Status AS Code,Status_Descricao AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Status_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
	End
	
if @Tipo = 'C' 
	Begin
		select 
			ID_Status AS Code,Status_Descricao AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Status_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ID_Status = @ID_Status
	End
	
if @Tipo = 'D'
	Begin
		select 
			ID_Status AS Code,Status_Descricao AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Status_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
			and ID_Status = @ID_Status
	End
	
if @Tipo = 'N' 
	Begin
		select 
			ID_Status AS Code,Status_Descricao AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Status_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			Status_Descricao = @Status_Descricao
	End
	
if  @Tipo = 'O'
	Begin
		select 
			ID_Status AS Code,Status_Descricao AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Status_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
			and Status_Descricao = @Status_Descricao
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select ID_Status AS Code,Status_Descricao AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Status_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			Status_Descricao = @Status_Descricao 
			and ID_Status <> @ID_Status

	End

GO
