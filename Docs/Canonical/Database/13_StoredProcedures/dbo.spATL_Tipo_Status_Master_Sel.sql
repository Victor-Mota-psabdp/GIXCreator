SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Tipo_Status_Master
CREATE procedure [dbo].[spATL_Tipo_Status_Master_Sel]
(
	@Cd_Tp_Status_Master	Varchar(3),
	@Nome_Tp_Status_Master	varchar(20),
	@Tipo					char(1)
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
		SELECT Cd_Tp_Status_Master AS Code,Nome_Tp_Status_Master AS [Master Master Status Type Name]
		from Tipo_Status_Master with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT Cd_Tp_Status_Master AS Code,Nome_Tp_Status_Master AS [Master Status Type Name] 
		from Tipo_Status_Master with(nolock)
		where Cd_Tp_Status_Master = @Cd_Tp_Status_Master
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT Cd_Tp_Status_Master AS Code,Nome_Tp_Status_Master AS [Master Status Type Name]
		from Tipo_Status_Master  with(nolock)
		where Nome_Tp_Status_Master = @Nome_Tp_Status_Master
	End
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT Cd_Tp_Status_Master AS Code,Nome_Tp_Status_Master AS [Master Status Type Name] 
		from Tipo_Status_Master  with(nolock)
		where Nome_Tp_Status_Master = @Nome_Tp_Status_Master AND Cd_Tp_Status_Master <> @Cd_Tp_Status_Master
	End

GO
