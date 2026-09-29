SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TMP_Lucrat](
	[StrMachine] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Processo] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cliente] [varchar](60) COLLATE Latin1_General_CI_AI NOT NULL,
	[Caixa] [float] NOT NULL,
	[Cta_Cte_House] [float] NOT NULL,
	[Cta_Cte_Master] [float] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
