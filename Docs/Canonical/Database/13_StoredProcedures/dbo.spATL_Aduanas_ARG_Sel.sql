SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELP Aduanas_ARG
CREATE procedure [dbo].[spATL_Aduanas_ARG_Sel]
(
	@CodAduana char(3),
	@Nome_Aduana varchar(30),
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
		select CodAduana AS Code,Nome_Aduana AS [Custom Name] from Aduanas_ARG with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select CodAduana AS Code,Nome_Aduana AS [Custom Name] from Aduanas_ARG with(nolock)
		where CodAduana = @CodAduana
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select CodAduana AS Code,Nome_Aduana AS [Custom Name] from Aduanas_ARG  with(nolock)
		where Nome_Aduana = @Nome_Aduana
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select CodAduana AS Code,Nome_Aduana AS [Custom Name] from Aduanas_ARG  with(nolock)
		where Nome_Aduana = @Nome_Aduana and CodAduana <> @CodAduana
	End

	
GO
