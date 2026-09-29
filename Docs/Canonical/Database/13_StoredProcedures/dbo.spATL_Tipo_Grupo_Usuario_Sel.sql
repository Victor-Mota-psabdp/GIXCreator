SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Grupo_Usuario
CREATE procedure [dbo].[spATL_Tipo_Grupo_Usuario_Sel]--'CSR','Faturamento','z'
(
	@ID_Tp_GR_Usuario char(3),
	@Nome_Tp_GR_Usuario varchar(30),
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

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		SELECT ID_Tp_GR_Usuario AS Code,Nome_Tp_GR_Usuario AS [Type Group User Name]
		FROM  dbo.Tipo_Grupo_Usuario with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT ID_Tp_GR_Usuario AS Code,Nome_Tp_GR_Usuario AS [Type Group User Name]
		FROM  dbo.Tipo_Grupo_Usuario with(nolock)
		where ID_Tp_GR_Usuario = @ID_Tp_GR_Usuario
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT ID_Tp_GR_Usuario AS Code,Nome_Tp_GR_Usuario AS [Type Group User Name]
		FROM  dbo.Tipo_Grupo_Usuario with(nolock)
		where Nome_Tp_GR_Usuario = @Nome_Tp_GR_Usuario
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		SELECT ID_Tp_GR_Usuario AS Code,Nome_Tp_GR_Usuario AS [Type Group User Name]
		FROM  dbo.Tipo_Grupo_Usuario with(nolock)
		where Nome_Tp_GR_Usuario = @Nome_Tp_GR_Usuario and ID_Tp_GR_Usuario <> @ID_Tp_GR_Usuario
	End

GO
