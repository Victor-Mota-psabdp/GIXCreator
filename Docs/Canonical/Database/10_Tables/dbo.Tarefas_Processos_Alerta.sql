SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Tarefas_Processos_Alerta](
	[ID_TP] [int] IDENTITY(1,1) NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID_Task] [int] NOT NULL,
	[Dt_Conclusao] [datetime] NULL,
	[Dt_Previsao] [datetime] NULL,
	[Cd_Usuario] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[ID_Alerta] [bigint] NULL,
	[Dt_Envio] [datetime] NULL,
 CONSTRAINT [PK_Tarefas_Processos_Alerta_1] PRIMARY KEY CLUSTERED 
(
	[ID_TP] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tarefas_Processos_Alerta] ADD  DEFAULT (getdate()) FOR [Dt_Ins]
GO
