SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spATLINT_AdvanceBooking_Sel NULL, 'I'
--sp_help AdvanceBookingHeader
CREATE procedure [dbo].[spATLINT_AdvanceBooking_Sel]
(

	@ID_ABH     Bigint,	
	@Tipo		CHAR(1) 

)
as


IF @Tipo = 'A' OR @Tipo = 'B'  
	BEGIN  
		Select 
			ABH.ID_ABH,
			ABH.messageId,
			ABH.senderID,
			ABH.receiverID,
			ABH.transDate,
			ABH.dt_ins,
			ABH.SystemCode,
			ABH.Dt_Ins_Pedido,
			ABH.Message
		from 
			ATL_INT.dbo.AdvanceBookingHeader ABH with(nolock)	
		--Where
		--	ABH.ID_ABH = @ID_ABH
	End

IF @Tipo = 'C' OR @Tipo = 'D'  
	BEGIN  
		Select 
			ABH.ID_ABH,
			ABH.messageId,
			ABH.senderID,
			ABH.receiverID,
			ABH.transDate,
			ABH.dt_ins,
			ABH.SystemCode,
			ABH.Dt_Ins_Pedido,
			ABH.Message
		from 
			ATL_INT.dbo.AdvanceBookingHeader ABH with(nolock)		
		Where
			ABH.ID_ABH = @ID_ABH
	End

IF @Tipo = 'N'  OR @Tipo = 'P'  
	BEGIN  
		Select 
			ABH.ID_ABH,
			ABH.messageId,
			ABH.senderID,
			ABH.receiverID,
			ABH.transDate,
			ABH.dt_ins,
			ABH.SystemCode,
			ABH.Dt_Ins_Pedido,
			ABH.Message
		from 
			ATL_INT.dbo.AdvanceBookingHeader ABH with(nolock)		
		Where
			ABH.Dt_Ins_Pedido is null
	End

IF @Tipo = 'I' --usada na tela do Integrated Received
	BEGIN  
		Select 
			ABH.ID_ABH,
			ABH.messageId,
			ABH.senderID,
			ABH.receiverID,
			ABH.transDate,
			ABH.dt_ins,
			ABH.SystemCode,
			ABH.Dt_Ins_Pedido,
			ABH.Message
		from 
			ATL_INT.dbo.AdvanceBookingHeader ABH with(nolock)		
		Where
			ABH.dt_ins > getdate() -31
	End


	


GO
