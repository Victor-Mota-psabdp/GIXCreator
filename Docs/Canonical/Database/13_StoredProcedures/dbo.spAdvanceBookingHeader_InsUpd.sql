SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     procedure [dbo].[spAdvanceBookingHeader_InsUpd]
(
	@ID_ABH     Bigint ,
	@messageId  varchar(200), 
	@senderID   varchar(200),
	@receiverID varchar(200),
	@transDate  varchar(200),
	@SystemCode numeric(2),
	@Dt_Ins_Pedido datetime
)
AS
BEGIN
--Exceção(try/CATCH)
--Transação
--sp_help spAdvanceBookingHeader_InsUpd(ver depois esta store o que e isso, se grava o erro ?)  
	BEGIN TRY
		Declare @ID_New as bigint;
			
		IF exists(select ID_ABH from atl_int.dbo.AdvanceBookingHeader where ID_ABH = @ID_ABH)
			Begin
				Update
					atl_int.dbo.AdvanceBookingHeader 
				Set
			  	   -- messageId=@messageId,
				   -- senderID=@senderID,
		    	--	receiverID=@receiverID,
				 --   transDate=@transDate,
				 --   SystemCode=SystemCode,
					Dt_Ins_Pedido=@Dt_Ins_Pedido
				Where
			       	ID_ABH = @ID_ABH 
					set @ID_New =  @ID_ABH
			End
		Else
			BEGIN
				
				Insert atl_int.dbo.AdvanceBookingHeader
				(
					messageId, 
					senderID,
					receiverID,
					transDate,
					SystemCode
				)
				Values
				(
					@messageId, 
					@senderID,
					@receiverID,
					@transDate,
					@SystemCode
				)
				set @ID_New = @@IDENTITY;
			END	

		Select @ID_New as Retorno;
		
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_MESSAGE() as Retorno;
	END CATCH	
END

GO
