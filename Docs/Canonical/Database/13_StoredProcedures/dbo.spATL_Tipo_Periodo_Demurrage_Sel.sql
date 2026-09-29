SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Tipo_Periodo_Demurrage_Sel]--'CSR','Faturamento','z'
(
	@Cd_Periodo int,
	@Ds_Periodo varchar(50),
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
		select Cd_Periodo AS Code,Ds_Periodo AS [Demurrage Period Type Name] from Tipo_Periodo_Demurrage with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select Cd_Periodo AS Code,Ds_Periodo AS [Demurrage Period Type Name] from Tipo_Periodo_Demurrage with(nolock)
		where Cd_Periodo = @Cd_Periodo
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		select Cd_Periodo AS Code,Ds_Periodo AS [Demurrage Period Type Name] from Tipo_Periodo_Demurrage  with(nolock)
		where Ds_Periodo = @Ds_Periodo
	End
	
if @Tipo = 'Z'-- or @Tipo = 'O'
	Begin
		select Cd_Periodo AS Code,Ds_Periodo AS [Demurrage Period Type Name] from Tipo_Periodo_Demurrage  with(nolock)
		where Ds_Periodo = @Ds_Periodo and Cd_Periodo <> @Cd_Periodo
	End

	

GO
