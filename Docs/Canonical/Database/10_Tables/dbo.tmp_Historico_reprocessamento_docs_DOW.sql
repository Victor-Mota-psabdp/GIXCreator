SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Historico_reprocessamento_docs_DOW](
	[Nome_Arquivo] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Smart_DOc] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Doc] [varchar](41) COLLATE Latin1_General_CI_AI NULL,
	[DMS_Arquivo] [varchar](39) COLLATE Latin1_General_CI_AI NULL,
	[DMS_Code] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[dt_creacao] [datetime] NULL,
	[Anexado_em] [datetime] NULL,
	[data_reprocessamento] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
