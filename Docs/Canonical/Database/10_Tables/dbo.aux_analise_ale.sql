SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[aux_analise_ale](
	[Nota_Fiscal] [varchar](8) COLLATE Latin1_General_CI_AI NOT NULL,
	[ref_Acesso] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[emissao] [datetime] NULL,
	[cd_pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
