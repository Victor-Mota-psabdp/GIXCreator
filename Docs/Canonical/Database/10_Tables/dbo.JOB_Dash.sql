SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JOB_Dash](
	[ID_Regra] [bigint] NOT NULL,
	[Nome_Regra] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Descricao_Regra] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Busca] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Operador] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dias] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Modal] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Descr_Ingles] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ordem] [int] NULL,
	[Status] [bit] NULL,
 CONSTRAINT [PK_JOB_Dash] PRIMARY KEY CLUSTERED 
(
	[ID_Regra] ASC,
	[Modal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
