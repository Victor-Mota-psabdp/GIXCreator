SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Eventos](
	[Arquivo_Eve] [varchar](25) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Evento] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[Sb_Tp_Evento] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Geracao] [datetime] NOT NULL,
	[Dt_Envio] [datetime] NULL,
	[Status_Eve] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
