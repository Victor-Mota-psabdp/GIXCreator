SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Alerta_Ocorrencia](
	[Dt_Ins] [datetime] NOT NULL,
	[Tp_Oper] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Ocor] [int] NOT NULL,
	[Cd_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Modal] [char](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Emails] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[ResponderPara] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Assunto] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Cd_usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Upd] [datetime] NULL,
	[Ativo] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
