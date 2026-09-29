CREATE TYPE [dbo].[PgtoClienteAX] AS TABLE(
	[ID] [bigint] NULL,
	[Num_Proc] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Tx] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[DC] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Invoice] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[AmountCur] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[AmountMST] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[DueDate] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ExchRate] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[OrigVoucher] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Voucher] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Canceled] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Status] [varchar](200) COLLATE Latin1_General_CI_AI NULL
)
GO
