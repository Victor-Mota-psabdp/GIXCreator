SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spLog_WebService_Rel]
AS

	select distinct Interface,isnull(Ref_Cliente,'')Ref_Cliente,Mensagem,   'Log_WebService' Tabela,
		Email [strDestinatario], 'Log ' + Interface [strAssunto], 
		--No Corpo da MSG colocar '|' para quebra de linha
		'Log Date:	' + convert(varchar(10),Log_Dt,103) + '||' + 
		'Interface:	' + Interface + '||' +
		'BDP Ref.:		' + isnull(Ref_BDP,'') + '|' + 
		'Customer Ref.:	' + isnull(Ref_Cliente,'') + '|' +
		'Reference:		' + isnull(Referencia,'') + '||' +
		'Message:	' + Mensagem + '|||||||' + 
		'Sent by BDP System' [strCorpoMSG],
		'' [strAnexoCaminho],
		'br.sao.sistemas@bdpint.com' [strResponderPara]
	from 
		Log_WebService
	where
		Dt_Envio is NULL and Email is NOT NULL
		and Ref_Cliente <> '0046003760'
/* Erbson - 18/11/2013 - isnull(Ref_Cliente,'')
	select distinct Interface,isnull(Ref_Cliente,''),Mensagem,   'Log_WebService' Tabela,
		Email [strDestinatario], 'Log ' + Interface [strAssunto], 
		--No Corpo da MSG colocar '|' para quebra de linha
		'Log Date:	' + convert(varchar(10),Log_Dt,103) + '||' + 
		'Interface:	' + Interface + '||' +
		'BDP Ref.:		' + isnull(Ref_BDP,'') + '|' + 
		'Customer Ref.:	' + isnull(Ref_Cliente,'') + '|' +
		'Reference:		' + isnull(Referencia,'') + '||' +
		'Message:	' + Mensagem + '|||||||' + 
		'Sent by BDP System' [strCorpoMSG],
		'' [strAnexoCaminho],
		'sistemas@bdp.com.br' [strResponderPara]
	from 
		Log_WebService
	where
		Dt_Envio is NULL and Email is NOT NULL
		
*/

--	select ID, 'Log_WebService' Tabela,
--		Email [strDestinatario], 'Log ' + Interface [strAssunto], 
--		--No Corpo da MSG colocar '|' para quebra de linha
--		'Log Date:	' + convert(varchar,Log_Dt) + '||' + 
--		'ID:	' + convert(varchar,ID) + '|' + 
--		'Interface:	' + Interface + '||' +
--		'BDP Ref.:		' + isnull(Ref_BDP,'') + '|' + 
--		'Customer Ref.:	' + isnull(Ref_Cliente,'') + '|' +
--		'Reference:		' + isnull(Referencia,'') + '||' +
--		'Message:	' + Mensagem + '|||||||' + 
--		'Sent by BDP System' [strCorpoMSG],
--		'' [strAnexoCaminho],
--		'sistemas@bdp.com.br' [strResponderPara]
--	from 
--		Log_WebService
--	where
--		Dt_Envio is NULL and Email is NOT NULL

GO
