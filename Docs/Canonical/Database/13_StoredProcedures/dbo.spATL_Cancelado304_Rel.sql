SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Cancelado304_Rel]
as
select distinct 
	'' Interface,
	'' Ref_Cliente,
	''Mensagem,
	''Tabela,
	--'anderson.lima@bdpint.com' [strDestinatario],
	'BR.SAO.BDPEXPORTS@bdpint.com;ar.expodqa@bdpint.com;cl.export@bdpint.com;br.sao.sistemas@bdpint.com' [strDestinatario],
	'**Alert - Shipment Canceled for LATAM***' [strAssunto],
	'This Shipment/Order was cancelled by Customer. Please check the ATL System and update accordingly. ||' +
	'ID: ' + convert(varchar(50), ID) + '|' + 
	'Order Reference:	' + Num_Pedido + '|' + 
	'|||||||' + 'Sent by BDP System' [strCorpoMSG],
	'' [strAnexoCaminho],
	'br.sao.sistemas@bdpint.com' [strResponderPara] 
from 
	Cancelado_304 C with(nolock)
where Dt_Envio is null

update Cancelado_304 set dt_Envio = GETDATE()where Dt_Envio is null

GO
