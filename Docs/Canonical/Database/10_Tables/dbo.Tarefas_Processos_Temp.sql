SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tarefas_Processos_Temp](
	[ID_House_Temp] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_Req] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Intl_Reference] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_TP_Temp] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_Task] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Task] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Conclusao] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Previsao] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Insert] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
