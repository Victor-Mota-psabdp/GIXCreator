SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Alerta_Email_Doc_Automatico_Historico](
	[Id] [int] NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Envio] [datetime] NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Alerta_Email_Doc_Automatico_Historico] ADD [Cd_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Alerta_Email_Doc_Automatico_Historico] ADD [Modal] [varchar](2) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Alerta_Email_Doc_Automatico_Historico] ADD [cd_tp_carga] [int] NULL
ALTER TABLE [dbo].[Alerta_Email_Doc_Automatico_Historico] ADD [Cd_Org] [varchar](3) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Alerta_Email_Doc_Automatico_Historico] ADD [Cd_Dst] [varchar](3) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Alerta_Email_Doc_Automatico_Historico] ADD [cd_tp_pedido] [char](1) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Alerta_Email_Doc_Automatico_Historico] ADD [Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Alerta_Email_Doc_Automatico_Historico] ADD [Cd_Transportadora] [varchar](10) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Alerta_Email_Doc_Automatico_Historico] ADD [Cd_Terminal] [varchar](10) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Alerta_Email_Doc_Automatico_Historico] ADD [ID_Alerta] [bigint] NULL

GO
SET ANSI_PADDING OFF
GO
