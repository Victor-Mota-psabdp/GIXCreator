SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Tarefas_Master](
	[ID_Task] [int] NOT NULL,
	[Nome_Task] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Modal] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ativo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dias] [float] NULL,
	[Tipo_Data] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Smart_Previsao] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Smart_Conclusao] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Standard] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Opcional] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Criacao] [datetime] NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Descr_Tarefa] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Consol] [char](1) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Tipo_Tarefas_Master] PRIMARY KEY CLUSTERED 
(
	[ID_Task] ASC,
	[Modal] ASC,
	[Cd_Pes_Grupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
