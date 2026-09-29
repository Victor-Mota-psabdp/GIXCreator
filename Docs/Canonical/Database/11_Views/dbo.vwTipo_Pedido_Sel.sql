SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_Pedido
CREATE VIEW [dbo].[vwTipo_Pedido_Sel]
AS
select 
	cd_Tp_Pedido [Code],nome_tp_pedido [Type of Shipment],Nome_TP_Pedido_PT [Type of Shipment PT]
from 
	Tipo_Pedido with(nolock)
where
	cd_Tp_Pedido <> 1

GO
