SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Log_AX_Servicos](
	[Cd_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_tp_tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[dt_ins] [datetime] NULL,
	[cd_usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Tipo] [varchar](1) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
