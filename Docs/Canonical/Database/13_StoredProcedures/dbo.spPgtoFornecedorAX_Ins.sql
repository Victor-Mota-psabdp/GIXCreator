SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spPgtoFornecedorAX_Ins]
(
	@Currency	varchar(50),
	@Invoice1	varchar(50),
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
	@PaymId	varchar(50),
	@ExchAdjustment	varchar(50),
	@OffsetRecid	varchar(50),
	@ExchRate	varchar(50),
	@OrigJournalNum	varchar(50),
	@OrigVoucher	varchar(50),
	@Canceled		varchar(50)
)
as

Insert into Pgto_Fornecedor_AX (
								Currency,
								Invoice1,
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
								PaymId,
								ExchAdjustment,
								OffsetRecid,
								ExchRate,
								OrigJournalNum,
								OrigVoucher,
								Canceled,
								Dt_Ins
								)
Values (
								@Currency,
								@Invoice1,
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
								@PaymId,
								@ExchAdjustment,
								@OffsetRecid,
								@ExchRate,
								@OrigJournalNum,
								@OrigVoucher,
								@Canceled,
								GETDATE()
)


GO
