SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_Alerta_LOG_Pedido_Rel]
as
select
'**Alerta - Log Pedido**' Interface,
'' Ref_Cliente,
''Mensagem,
''Tabela,
'br.sao.sistemas@bdpint.com' [strDestinatario],
'Alerta - Log Pedido' [strAssunto],
'Cd_pedido: ' + convert(varchar(25),C.cd_pedido) + '|' + 
'Numero do Pedido:' + C.num_pedido +'|'+
'|||||||' +'Sent by BDP System' [strCorpoMSG],
NULL,
GETDATE(),
NULL,
NULL,
'' [strAnexoCaminho],
'br.sao.sistemas@bdpint.com' [strResponderPara],
'' Campo_Dados 
 from Log_Pedido C with(nolock)
 





GO
