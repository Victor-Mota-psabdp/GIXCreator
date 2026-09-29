SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spPgtoClienteAX_Ins]
(
	@Currency	varchar(50),
	@Invoice1	varchar(50),
	@Product	varchar(50),
	@JobNumber	varchar(50),
	@AccountNum	varchar(50),
	@TransDate	varchar(50),
	@Voucher	varchar(50),
	@Invoice	varchar(50),
	@Txt	varchar(100),
	@AmountCur	varchar(50),
	@SettleAmountCur	varchar(50),
	@AmountMST	varchar(50),
	@SettleAmountMST	varchar(50),
	@CurrencyCode	varchar(50),
	@DueDate	varchar(50),
	@LastSettleVoucher	varchar(50),
	@LastSettleDate	varchar(50),
	@Closed	varchar(50),
	@PaymReference	varchar(50),
	@OffsetRecid	varchar(50),
	@PaymId	varchar(50),
	@recVersion	varchar(50),
	@RecId	varchar(50),
	@Canceled	varchar(50)
)
as

Insert into Pgto_Cliente_AX (
							Currency,
							Invoice1,
							Product,
							JobNumber,
							AccountNum,
							TransDate,
							Voucher,
							Invoice,
							Txt,
							AmountCur,
							SettleAmountCur,
							AmountMST,
							SettleAmountMST,
							CurrencyCode,
							DueDate,
							LastSettleVoucher,
							LastSettleDate,
							Closed,
							PaymReference,
							OffsetRecid,
							PaymId,
							recVersion,
							RecId,
							Canceled,
							Dt_Ins

								)
Values (
							@Currency,
							@Invoice1,
							@Product,
							@JobNumber,
							@AccountNum,
							@TransDate,
							@Voucher,
							@Invoice,
							@Txt,
							@AmountCur,
							@SettleAmountCur,
							@AmountMST,
							@SettleAmountMST,
							@CurrencyCode,
							@DueDate,
							@LastSettleVoucher,
							@LastSettleDate,
							@Closed,
							@PaymReference,
							@OffsetRecid,
							@PaymId,
							@recVersion,
							@RecId,
							@Canceled,
							GETDATE()
)


GO
