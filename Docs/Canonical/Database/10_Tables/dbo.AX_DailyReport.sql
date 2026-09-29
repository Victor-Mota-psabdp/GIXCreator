SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AX_DailyReport](
	[System] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Type] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Job] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Transaction Dt] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Voucher] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[AX Charge Code] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[ATL Charge Description] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Ledger Account] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Currency] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Value] [float] NULL,
	[BRL Value] [float] NULL,
	[ATL Charge Code] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Registered on] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Date] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
