SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_JMDMaster_Rel]
as
select 
	'' Interface,
	'' Ref_Cliente,
	''Mensagem,
	''Tabela,
	'br.sao.sistemas@bdpint.com' [strDestinatario],
	'Alerta - Arquivo JMD não criado' [strAssunto],
	'BDP Ref. : ' + E.Num_Proc + '|' + 
	'DT Envio AX.:		' + convert(varchar(50),Dt_Envio_AX,103) + '|' + 
	'|||||||' + 'Sent by BDP System' [strCorpoMSG],
	'' [strAnexoCaminho],
	'br.sao.sistemas@bdpint.com' [strResponderPara] 
from Exchange_JMD_AX_ATL E with(nolock)
left join AX_Master_XML A with(nolock) on E.Num_Proc = A.Num_Proc
where E.Dt_Envio_AX >= GETDATE()-60 and A.Num_Proc is null order by Dt_Envio_AX

GO
