SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tmp_Auditor](
	[TmpMachine] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpProcesso] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpCd_Tp_Tx] [char](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpDC] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpValor] [decimal](12, 2) NOT NULL,
	[Tmp_Dt_Ins] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Tmp_Pago] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Tmp_Cliente] [varchar](60) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
