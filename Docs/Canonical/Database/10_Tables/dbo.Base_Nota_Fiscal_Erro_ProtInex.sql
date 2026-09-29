SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Base_Nota_Fiscal_Erro_ProtInex](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Nota_Fiscal] [varchar](8) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ref_Acesso] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[XML_DOC] [nvarchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Arquivo] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Codigo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Mensagem] [nvarchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Correcao] [nvarchar](max) COLLATE Latin1_General_CI_AI NULL,
	[dt_Protocolo] [datetime] NULL,
	[protocolo] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
