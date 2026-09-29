SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Hist_Geral_Sistemas_2009to2022](
	[HSGProcesso] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[HSGSeq] [int] NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Ocor] [int] NOT NULL,
	[HSDDescricao] [varchar](2000) COLLATE Latin1_General_CI_AI NOT NULL,
	[HSGData] [datetime] NOT NULL,
	[HSGDataFU] [datetime] NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[HSGDataConf] [datetime] NULL,
	[Disp_Cliente] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Origem] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[ID_NC] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[idhistgeralsys] [bigint] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
