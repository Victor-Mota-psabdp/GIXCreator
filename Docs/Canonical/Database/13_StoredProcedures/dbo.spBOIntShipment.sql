SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spBOIntShipment
	@Pedido	Varchar(30),
	@item	varchar(4)

as
--23-06
--Procedure criada para intergração BO - Busca o numero do Shipment

select num_proc from pedido_ship PS
Left Join Pedido PD on PD.cd_pedido=PS.cd_pedido
Where num_pedido=@Pedido and item=@item


GO
