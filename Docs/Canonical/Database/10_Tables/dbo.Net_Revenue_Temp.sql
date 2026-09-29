SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Net_Revenue_Temp](
	[Ref_BDP] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Custo_Processo_SemImpostos] [float] NULL,
	[Net_revenue] [decimal](10, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
