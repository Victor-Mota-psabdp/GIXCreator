SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Idioma
CREATE procedure [dbo].[spATL_Idioma_Sel]--'CSR','Faturamento','z'
(
	@Cd_Idioma char(3),
	@Nome_Idioma varchar(30),
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
		select Cd_Idioma AS Code,Nome_Idioma AS [Language Name] from Idioma with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Cd_Idioma AS Code,Nome_Idioma AS [Language Name] from Idioma with(nolock)
		where Cd_Idioma = @Cd_Idioma
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select Cd_Idioma AS Code,Nome_Idioma AS [Language Name] from Idioma  with(nolock)
		where Nome_Idioma = @Nome_Idioma
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select Cd_Idioma AS Code,Nome_Idioma AS [Language Name] from Idioma  with(nolock)
		where Nome_Idioma = @Nome_Idioma and Cd_Idioma <> @Cd_Idioma
	End

	
GO
