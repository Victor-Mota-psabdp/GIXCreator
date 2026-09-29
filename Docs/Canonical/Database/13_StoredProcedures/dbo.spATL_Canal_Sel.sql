SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Canal_Sel]--'CSR','Faturamento','z'
(
	@Id Int,
	@Canal varchar(30),
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
		select Id AS Code,Canal AS [Channel Name] from Canal with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Id AS Code,Canal AS [Channel Name] from Canal with(nolock)
		where Id = @Id
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select Id AS Code,Canal AS [Channel Name] from Canal with(nolock)
		where Canal = @Canal
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select Id AS Code,Canal AS [Channel Name] from Canal with(nolock)
		where Canal = @Canal and Id <> @Id
	End

	

GO
