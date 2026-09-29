SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_Pedido_Container_Mensagem_Sel]--'187051','27752922','','BRAZIL','MSCU1007249'
(
	@Cd_Pedido	varchar(25),
	@NumPedido	varchar(100),	
	@VerificaSOD varchar(100),
	@PaisOrigem varchar(100),
	@NumeroContainerAMais varchar(MAX)	
)
as

set @VerificaSOD = (select A.Nome_Raz_Soc from Pedido P join Pessoa A on P.Cd_Seller = A.Cd_Pes where Cd_pedido = @Cd_Pedido)

Declare @MSG as Varchar(max)
set @MSG = (select 
--'Containers que não estão mais na mensagem '+ @NumeroContainerAMais + '||||' +

'================================================================================'  + '||' +
'                       STATUS FOR INCOMING EXPORT ORDER						 '	+ '|' +
'     SELLER:'+ @VerificaSOD + ' SELLER REF: ' + @NumPedido + '     '  + '||' +

'================================================================================'  + '||' +

'EDI TRANSACTION TYPE: 304' + '||' +

'CONTAINER HAS CHANGED:  '+ @NumeroContainerAMais + '|' +
'VERIFY AND CHANGE MANUALLY '+ '|' +
'SELLER:'+ @VerificaSOD + ' SELLER REF: ' + @NumPedido + '                       RECORD LOCK'+ '|' +

'* NOTE: PLEASE CORRECT ANY ERRORS LISTED.'+ '||' +
'TRANSACTION SUCCESSFULLY RECEIVED' + '|' )


if @PaisOrigem = 'BRAZIL'
	select top 1
		Num_Proc [JOB],
		'STATUS FOR INCOMING EXPORT ORDER'[Assunto],
		@MSG [MSG],
		'carlos.eduardo@bdpint.com;erbson.soares@bdpint.com'[Destinatarios],
		'carlos.eduardo@bdpint.com'[ResponderPara]
	from 
		Pedido_Ship 
	where 
		cd_pedido = @Cd_Pedido

if @PaisOrigem= 'ARGENTINA'
	select top 1
		Num_Proc [JOB],
		'STATUS FOR INCOMING EXPORT ORDER - Argentina'[Assunto],
		@MSG [MSG],
		'carlos.eduardo@bdpint.com;erbson.soares@bdpint.com'[Destinatarios],
		'carlos.eduardo@bdpint.com'[ResponderPara]
	from 
		Pedido_Ship 
	where 
		cd_pedido = @Cd_Pedido

if @PaisOrigem= 'CHILE'
	select top 1
		Num_Proc [JOB],
		'STATUS FOR INCOMING EXPORT ORDER - Chile'[Assunto],
		@MSG [MSG],
		'carlos.eduardo@bdpint.com;erbson.soares@bdpint.com'[Destinatarios],
		'carlos.eduardo@bdpint.com'[ResponderPara]
	from 
		Pedido_Ship 
	where 
		cd_pedido = @Cd_Pedido
		
		
		
		
/*
set @MSG = (select 
'Containers que não estão mais na mensagem '+ @NumeroContainerAMais + '||||' +

'================================================================================'  + '||' +
'                       STATUS FOR INCOMING EXPORT ORDER						 '	+ '|' +
'                   SELLER:'+ @VerificaSOD + 'SELLER REF: ' + @NumPedido + '     '  + '||' +

'================================================================================'  + '||' +

'EDI TRANSACTION TYPE: 304' + '||' +

'MODE OF TRANS HAS CHANGED,  EDI STATES:   COPS STATES: V'+ '|' +
'VERIFY AND CHANGE MANUALLY'+ '|' +

'SELLER:'+ @VerificaSOD + 'SELLER REF: ' + @NumPedido + '                       RECORD LOCK'+ '|' +

'* NOTE: PLEASE CORRECT ANY ERRORS LISTED.'+ '|' +
'TRANSACTION SUCCESSFULLY RECEIVED' + '|' )*/
	
	
	
		

GO
