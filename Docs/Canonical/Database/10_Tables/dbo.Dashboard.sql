SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Dashboard](
	[Nome_Rotina] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Teste] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Informacao] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Data_Info] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Caminho] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[DataIns] [datetime] NOT NULL,
	[Status] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Limit] [varchar](50) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
