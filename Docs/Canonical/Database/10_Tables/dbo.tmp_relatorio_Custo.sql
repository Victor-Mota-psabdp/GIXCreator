SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_relatorio_Custo](
	[CD_PES] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[APELIDO] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[num_proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[dt_conclusao] [datetime] NULL,
	[Nome_Tp_Tx] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[VLR_ITEM_CUSTO] [decimal](10, 2) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
