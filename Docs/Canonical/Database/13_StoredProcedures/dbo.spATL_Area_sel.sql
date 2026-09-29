SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Area_Sel]--'CSR','Faturamento','z'
(
	@Cd_Area char(3),
	@Nome_Area varchar(30),
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
		select Cd_Area AS Code,Nome_Area AS [Department Name] from Area with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Cd_Area AS Code,Nome_Area AS [Department Name] from Area with(nolock)
		where Cd_Area = @Cd_Area
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select Cd_Area AS Code,Nome_Area AS [Department Name] from Area  with(nolock)
		where Nome_Area = @Nome_Area
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select Cd_Area AS Code,Nome_Area AS [Department Name] from Area  with(nolock)
		where Nome_Area = @Nome_Area and Cd_Area <> @Cd_Area
	End

	
GO
