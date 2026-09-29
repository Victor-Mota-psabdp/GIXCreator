SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Alerta_Padrao_Historico](
	[ID] [int] NOT NULL,
	[JOB] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Emails] [varchar](500) COLLATE Latin1_General_CI_AI NOT NULL,
	[Conteudo] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[DocAnexos] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[dt_ins] [datetime] NOT NULL,
	[dt_envio] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
