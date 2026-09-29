SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TempPgtoFornecedorAX](
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
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
