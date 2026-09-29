SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Fatura_Draft](
	[FatCod] [varchar](19) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[FatDtVenc] [datetime] NOT NULL,
	[FatObs] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[FatStatus] [smallint] NULL,
	[FatDtEmissao] [datetime] NULL,
	[Dt_Ins] [datetime] NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[DT_Canc] [datetime] NULL,
	[cd_usuario_Canc] [varchar](6) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
