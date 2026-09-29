SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Pedido
CREATE procedure [dbo].[spATL_Tipo_Pedido_Sel](
	@cd_Tp_Pedido	varChar(1),
	@Nome_Tp_Pedido	varChar(50),
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

if @Tipo = 'A'  OR @Tipo = 'B'
	Begin
		select 
			cd_Tp_Pedido [Code],nome_tp_pedido [Type of Shipment],Nome_TP_Pedido_PT [Type of Shipment PT]
		from 
			Tipo_Pedido with(nolock)
	End

if @Tipo = 'C'  OR @Tipo = 'D'
	Begin
		select 
			cd_Tp_Pedido [Code],nome_tp_pedido [Type of Shipment],Nome_TP_Pedido_PT [Type of Shipment PT]
		from 
			Tipo_Pedido with(nolock)
		where 
			cd_Tp_Pedido = @cd_Tp_Pedido
			and cd_Tp_Pedido <>1
	End
	
	
if @Tipo = 'N'  OR @Tipo = 'O'
	Begin
		select 
			cd_Tp_Pedido [Code],nome_tp_pedido [Type of Shipment],Nome_TP_Pedido_PT [Type of Shipment PT]
		from 
			Tipo_Pedido with(nolock)
		where 
			nome_tp_pedido = @nome_tp_pedido
	End

	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		select 
			cd_Tp_Pedido [Code],nome_tp_pedido [Type of Shipment],Nome_TP_Pedido_PT [Type of Shipment PT]
		from 
			Tipo_Pedido with(nolock)
		where 
			nome_tp_pedido = @nome_tp_pedido AND cd_Tp_Pedido <> @cd_Tp_Pedido
	End

GO
