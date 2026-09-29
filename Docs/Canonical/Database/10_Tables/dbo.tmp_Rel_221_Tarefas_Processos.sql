SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Rel_221_Tarefas_Processos](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID_Task] [int] NOT NULL,
	[Dt_Conclusao] [datetime] NULL,
	[Dt_Previsao] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
