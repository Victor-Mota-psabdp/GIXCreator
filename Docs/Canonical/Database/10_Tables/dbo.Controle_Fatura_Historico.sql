SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Controle_Fatura_Historico](
	[cd_controlefatura] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_nc] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[disponivel] [char](10) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
