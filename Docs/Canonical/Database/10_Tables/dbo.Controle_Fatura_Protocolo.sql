SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Controle_Fatura_Protocolo](
	[cd_protocolo] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_controlefatura] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[email] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[dt_creacao] [datetime] NULL,
	[cd_usuario] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
