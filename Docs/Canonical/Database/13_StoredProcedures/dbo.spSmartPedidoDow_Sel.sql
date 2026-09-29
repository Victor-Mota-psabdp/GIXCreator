SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSmartPedidoDow_Sel]
(
	@Num_Proc	Varchar(16)
)
	
AS
/*

	Personalização devido ao EDI 304, no EDI o Numero da Ordem vem como numero do Shipment, é necessário enviar para o Smart o numero da ordem
	Anderson 04/12/2012
	
	26/09/2019 - alterado para PD.Num_Pedido
	10/11/2022 - Cadu, alterado para enviar o numero com os zero na frente como chega na integração do 304
*/

select distinct		
	CO1.campo_dados num_po
	,dt_pedido
from Pedido_Ship PS
	Join campo_ordem	CO3 with(nolock) on PS.cd_pedido=CO3.cd_pedido and CO3.id_campo=3 and CO3.campo_dados='Via Integração: 304'
	Join campo_ordem	CO1 with(nolock) on PS.cd_pedido=CO1.cd_pedido and CO1.id_campo=1
	Join Pedido			PD with(nolock) on PS.cd_pedido=PD.cd_pedido
where 
	 num_proc=@num_proc



--select 
----customer_Po num_po , dt_pedido
--	PD.num_pedido num_po , dt_pedido
--from 
--	campo_ordem  CO with(nolock)
--	Join Pedido_Ship PS with(nolock) on PS.cd_pedido=CO.cd_pedido
--	Join Pedido PD with(nolock) on PS.cd_pedido=PD.cd_pedido
--where 
--	id_campo=3
--	and campo_dados='Via Integração: 304'
--	and num_proc=@num_proc





	

GO
