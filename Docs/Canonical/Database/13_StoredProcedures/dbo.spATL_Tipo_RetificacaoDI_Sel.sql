SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Tipo_RetificacaoDI
Create procedure [dbo].[spATL_Tipo_RetificacaoDI_Sel]
(
	@ID_TP_RET		BigInt,
    @NOME_TP_RET	varchar(MAX), 
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
		select ID_TP_RET AS Code,NOME_TP_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
		Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_RetificacaoDI DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		
	End
if @Tipo = 'B'
	Begin
		select 
			ID_TP_RET AS Code,NOME_TP_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_RetificacaoDI DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
	End
	
if @Tipo = 'C' 
	Begin
		select 
			ID_TP_RET AS Code,NOME_TP_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_RetificacaoDI DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ID_TP_RET = @ID_TP_RET
	End
	
if @Tipo = 'D'
	Begin
		select 
			ID_TP_RET AS Code,NOME_TP_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_RetificacaoDI DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
			and ID_TP_RET = @ID_TP_RET
	End
	
if @Tipo = 'N' 
	Begin
		select 
			ID_TP_RET AS Code,NOME_TP_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_RetificacaoDI DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			NOME_TP_RET = @NOME_TP_RET
	End
	
if  @Tipo = 'O'
	Begin
		select 
			ID_TP_RET AS Code,NOME_TP_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_RetificacaoDI DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			ativo = 1
			and NOME_TP_RET = @NOME_TP_RET
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select ID_TP_RET AS Code,NOME_TP_RET AS [Type Name],Ativo [Active],DI.Cd_Usuario [User Code], 
			Nome_Usuario [User Name],dt_ins [Insert Date]
		from Tipo_RetificacaoDI DI with(nolock)
		left join Usuario U with(nolock) on U.Cd_Usuario = DI.Cd_Usuario
		where
			NOME_TP_RET = @NOME_TP_RET 
			and ID_TP_RET <> @ID_TP_RET

	End

GO
