SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Nivel
CREATE procedure [dbo].[spATL_Nivel_Sel]
(
	@Cd_Nivel char(3),
	@Tipo_Nivel varchar(30),
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
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select Cd_Nivel AS Code,Tipo_Nivel AS [Level Name] from Nivel with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Cd_Nivel AS Code,Tipo_Nivel AS [Level Name] from Nivel with(nolock)
		where Cd_Nivel = @Cd_Nivel
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select Cd_Nivel AS Code,Tipo_Nivel AS [Level Name] from Nivel  with(nolock)
		where Tipo_Nivel = @Tipo_Nivel
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select Cd_Nivel AS Code,Tipo_Nivel AS [Level Name] from Nivel  with(nolock)
		where Tipo_Nivel = @Tipo_Nivel AND Cd_Nivel <> @Cd_Nivel
	End
	

	
GO
