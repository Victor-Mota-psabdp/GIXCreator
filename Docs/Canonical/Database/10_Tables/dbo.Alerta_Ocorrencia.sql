SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Alerta_Ocorrencia](
	[Cd_Tp_Ocor] [int] NOT NULL,
	[Cd_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Modal] [char](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Emails] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[ResponderPara] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Assunto] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [datetime] NULL,
	[Ativo] [bit] NULL,
 CONSTRAINT [PK_Tipo_Ocorrencia_Alera] PRIMARY KEY CLUSTERED 
(
	[Cd_Tp_Ocor] ASC,
	[Cd_Pes_Grupo] ASC,
	[Modal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
