SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Variavel
CREATE procedure [dbo].[spATL_Tipo_Variavel_Sel]--'CSR','Faturamento','z'
(
	@Cd_Tipo varchar(1),
	@Nome_Tipo varchar(30),
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
		select Cd_Tipo AS Code,Nome_Tipo AS [Type Name] from Tipo_Variavel with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Cd_Tipo AS Code,Nome_Tipo AS [Type Name] from Tipo_Variavel with(nolock)
		where Cd_Tipo = @Cd_Tipo
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select Cd_Tipo AS Code,Nome_Tipo AS [Type Name] from Tipo_Variavel  with(nolock)
		where Nome_Tipo = @Nome_Tipo
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select Cd_Tipo AS Code,Nome_Tipo AS [Type Name] from Tipo_Variavel  with(nolock)
		where Nome_Tipo = @Nome_Tipo and Cd_Tipo <> @Cd_Tipo
	End

	
GO
