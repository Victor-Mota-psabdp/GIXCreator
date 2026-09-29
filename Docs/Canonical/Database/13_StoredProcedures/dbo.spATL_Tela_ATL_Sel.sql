SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tela_ATL
CREATE procedure [dbo].[spATL_Tela_ATL_Sel](
	@Cd_Tela char(3),
	@Nome_Tela varchar(50),
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
		select Cd_Tela AS Code,Nome_Tela AS [Screen Name] from Tela_ATL with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Cd_Tela AS Code,Nome_Tela AS [Screen Name] from Tela_ATL with(nolock)
		where Cd_Tela = @Cd_Tela
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select Cd_Tela AS Code,Nome_Tela AS [Screen Name] from Tela_ATL  with(nolock)
		where Nome_Tela = @Nome_Tela
	End
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select Cd_Tela AS Code,Nome_Tela AS [Screen Name] from Tela_ATL  with(nolock)
		where Nome_Tela = @Nome_Tela AND Cd_Tela <> @Cd_Tela
	End
	

	
GO
