SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Solicitacao_Retificacao](
	[NUM_SOLRET] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[DT_SOLICITACAO] [datetime] NOT NULL,
	[CD_SOLICITANTE] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID_TP_SOLRET] [bigint] NOT NULL,
	[NUM_PROC] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[CD_OPERADOR] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[NR_RETIFICACAO] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[ID_USUARIO_SOLRET] [bigint] NULL,
	[DT_RETIFICACAO] [datetime] NULL,
	[ID_STATUS] [bigint] NOT NULL,
	[DT_RCTO_AUTO_INFRACAO] [datetime] NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Solicitacao_Retificacao] ADD [NR_AUTO_INFRACAO] [varchar](50) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Solicitacao_Retificacao] ADD [VL_AUTO_INFRACAO] [decimal](18, 2) NULL
ALTER TABLE [dbo].[Solicitacao_Retificacao] ADD [DT_ENV_ADVOGADO] [datetime] NULL
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[Solicitacao_Retificacao] ADD [NM_ESCRITORIO_ADVOCATICIO] [varchar](100) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Solicitacao_Retificacao] ADD [ATIVO] [bit] NOT NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Solicitacao_Retificacao] ADD [CD_FUNCIONARIO] [varchar](10) COLLATE Latin1_General_CI_AI NULL

GO
SET ANSI_PADDING OFF
GO
