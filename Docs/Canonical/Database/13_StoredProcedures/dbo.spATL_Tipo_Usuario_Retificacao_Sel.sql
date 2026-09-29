SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_Usuario_Retificacao
CREATE procedure [dbo].[spATL_Tipo_Usuario_Retificacao_Sel]
(
	@ID_TP_USUARIO_RET		BigInt,
    @Nome_TP_USUARIO_RET	varchar(50), 
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
		select ID_TP_USUARIO_RET AS Code,Nome_TP_USUARIO_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Usuario_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario		
	End
if @Tipo = 'B'
	Begin
		select 
			ID_TP_USUARIO_RET AS Code,Nome_TP_USUARIO_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Usuario_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
	End
	
if @Tipo = 'C' 
	Begin
		select 
			ID_TP_USUARIO_RET AS Code,Nome_TP_USUARIO_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Usuario_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ID_TP_USUARIO_RET = @ID_TP_USUARIO_RET
	End
	
if @Tipo = 'D'
	Begin
		select 
			ID_TP_USUARIO_RET AS Code,Nome_TP_USUARIO_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Usuario_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
			and ID_TP_USUARIO_RET = @ID_TP_USUARIO_RET
	End
	
if @Tipo = 'N' 
	Begin
		select 
			ID_TP_USUARIO_RET AS Code,Nome_TP_USUARIO_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Usuario_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			Nome_TP_USUARIO_RET = @Nome_TP_USUARIO_RET
	End
	
if  @Tipo = 'O'
	Begin
		select 
			ID_TP_USUARIO_RET AS Code,Nome_TP_USUARIO_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Usuario_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
			and Nome_TP_USUARIO_RET = @Nome_TP_USUARIO_RET
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select ID_TP_USUARIO_RET AS Code,Nome_TP_USUARIO_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_Usuario_Retificacao DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			Nome_TP_USUARIO_RET = @Nome_TP_USUARIO_RET 
			and ID_TP_USUARIO_RET <> @ID_TP_USUARIO_RET

	End

GO
