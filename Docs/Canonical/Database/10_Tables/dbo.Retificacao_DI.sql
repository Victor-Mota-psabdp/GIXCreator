SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Retificacao_DI](
	[NUM_PROC] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[DT_SOLICITACAO] [datetime] NOT NULL,
	[CD_SOLICITANTE] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[NUM_DI] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[CD_DESPACHANTE] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[NR_RETIFICACAO] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[DT_RETIFICACAO] [datetime] NULL,
	[ID_TP_RET] [bigint] NULL,
	[ID_TP_USUARIO_RET] [bigint] NULL,
	[VL_TOTAL_IMPOSTOS] [decimal](18, 2) NULL,
	[VL_TOTAL_IMPOSTOS_RECOLHIDOS] [decimal](18, 2) NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Retificacao_DI] ADD [NOME_TAX_CLIENTE] [varchar](100) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Retificacao_DI] ADD [NOME_ITO_CLIENTE] [varchar](100) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Retificacao_DI] ADD [QTDE_ADICOES_DI] [bigint] NULL
ALTER TABLE [dbo].[Retificacao_DI] ADD [QTDE_ADICOES_RETIFICADA] [bigint] NULL
ALTER TABLE [dbo].[Retificacao_DI] ADD [ID_STATUS] [bigint] NOT NULL
ALTER TABLE [dbo].[Retificacao_DI] ADD [DT_ULTIMA] [datetime] NULL
ALTER TABLE [dbo].[Retificacao_DI] ADD [ATIVO] [bit] NOT NULL
ALTER TABLE [dbo].[Retificacao_DI] ADD [DE] [varchar](250) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Retificacao_DI] ADD [PARA] [varchar](250) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Retificacao_DI] ADD [Id_Tp_Proc_Adm] [bigint] NULL
ALTER TABLE [dbo].[Retificacao_DI] ADD [Responsavel] [varchar](50) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Retificacao_DI] ADD [Notas] [varchar](250) COLLATE Latin1_General_CI_AI NULL

GO
SET ANSI_PADDING OFF
GO
