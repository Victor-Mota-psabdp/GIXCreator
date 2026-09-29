SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Rel_SCHCASS_INVOICE](
	[Invoice_Seq] [int] NULL,
	[fatCod] [varchar](17) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[fatdtvenc] [datetime] NOT NULL,
	[fatStatus] [smallint] NULL,
	[FatDTEmissao] [datetime] NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[IDItemFat] [bigint] NOT NULL,
	[CD_tp_tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[dc] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[CD_TP_MOEDA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[VLR_ORG] [decimal](12, 2) NOT NULL,
	[VLR_RS] [decimal](12, 2) NULL,
	[PARIDADE] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
