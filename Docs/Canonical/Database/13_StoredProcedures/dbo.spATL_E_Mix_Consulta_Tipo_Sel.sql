SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help E_Mix_Consulta_Tipo
CREATE procedure [dbo].[spATL_E_Mix_Consulta_Tipo_Sel]--'CSR','Faturamento','z'
(
	@ID_Consulta_Tipo int,
	@Nome_Consulta_Tipo varchar(30),
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
		select ID_Consulta_Tipo AS Code,Nome_Consulta_Tipo AS [Type Name] from E_Mix_Consulta_Tipo with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select ID_Consulta_Tipo AS Code,Nome_Consulta_Tipo AS [Type Name] from E_Mix_Consulta_Tipo with(nolock)
		where ID_Consulta_Tipo = @ID_Consulta_Tipo
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select ID_Consulta_Tipo AS Code,Nome_Consulta_Tipo AS [Type Name] from E_Mix_Consulta_Tipo with(nolock)
		where Nome_Consulta_Tipo = @Nome_Consulta_Tipo
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select ID_Consulta_Tipo AS Code,Nome_Consulta_Tipo AS [Department Name] from E_Mix_Consulta_Tipo  with(nolock)
		where Nome_Consulta_Tipo = @Nome_Consulta_Tipo and ID_Consulta_Tipo <> @ID_Consulta_Tipo
	End

	

GO
