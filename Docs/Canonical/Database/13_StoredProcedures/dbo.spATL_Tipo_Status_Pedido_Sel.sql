SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Status_Pedido
CREATE procedure [dbo].[spATL_Tipo_Status_Pedido_Sel]
(
	@Cd_Tp_Status_Pedido	Varchar(3),
	@Nome_Tp_Status_Pedido	varchar(20),
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
		SELECT Cd_Tp_Status_Pedido AS Code,Nome_Tp_Status_Pedido AS [Status Type Name]
		from Tipo_Status_Pedido with(nolock)
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT Cd_Tp_Status_Pedido AS Code,Nome_Tp_Status_Pedido AS [Status Type Name] 
		from Tipo_Status_Pedido with(nolock)
		where Cd_Tp_Status_Pedido = @Cd_Tp_Status_Pedido
	End
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT Cd_Tp_Status_Pedido AS Code,Nome_Tp_Status_Pedido AS [Status Type Name]
		from Tipo_Status_Pedido  with(nolock)
		where Nome_Tp_Status_Pedido = @Nome_Tp_Status_Pedido
	End
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT Cd_Tp_Status_Pedido AS Code,Nome_Tp_Status_Pedido AS [Status Type Name] 
		from Tipo_Status_Pedido  with(nolock)
		where Nome_Tp_Status_Pedido = @Nome_Tp_Status_Pedido AND Cd_Tp_Status_Pedido <> @Cd_Tp_Status_Pedido
	End

GO
