SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Tarefas_Processos_Alerta](
	[Id_Log] [bigint] IDENTITY(1,1) NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[ID_Task] [int] NULL,
	[Dt_Conclusao] [datetime] NULL,
	[Dt_Previsao] [datetime] NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[ID_Alerta] [bigint] NULL,
	[Dt_Envio] [datetime] NULL,
	[Dt_Log] [datetime] NULL,
	[Log_Message] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Log_Tarefas_Processos_Alerta] PRIMARY KEY CLUSTERED 
(
	[Id_Log] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
