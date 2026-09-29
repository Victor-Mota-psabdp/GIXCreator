SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Fatura_Consolidada](
	[Id] [int] NOT NULL,
	[Data] [datetime] NULL,
	[cd_grupo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[cd_cliente] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[dt_vencimento] [datetime] NULL,
	[ativo] [bit] NULL,
	[cd_usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
