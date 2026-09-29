SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pgto_Fornecedor_AX](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Currency] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Invoice1] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[JobNumber] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[AccountNum] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[TransDate] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Voucher] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Invoice] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Txt] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[AmountCur] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[SettleAmountCur] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[AmountMST] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[SettleAmountMST] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CurrencyCode] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DueDate] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[LastSettleVoucher] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[LastSettleDate] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Closed] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[PaymId] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ExchAdjustment] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[OffsetRecid] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ExchRate] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[OrigJournalNum] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[OrigVoucher] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Canceled] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Dt_Upd_ATL] [datetime] NULL,
	[Status] [varchar](max) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
