SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tmp_Fatura](
	[StrMachine] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpProcesso] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpCd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpDC] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpCdTpMoeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[TmpVlrOrg] [decimal](12, 2) NULL,
	[TmpVlrRef] [decimal](12, 2) NULL,
	[TmpVlrRS] [decimal](12, 2) NULL,
	[TmpParidade] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
