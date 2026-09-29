SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Alteracao_Exchange_FComex](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[Exchange_id] [bigint] NOT NULL,
	[Processo_id] [bigint] NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Lido_Processo] [bit] NULL,
	[Dt_Leitura_Processo] [datetime] NULL,
	[Dt_Fim_Processo] [datetime] NULL,
	[Id_Empresa] [bigint] NOT NULL,
	[Processo] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
