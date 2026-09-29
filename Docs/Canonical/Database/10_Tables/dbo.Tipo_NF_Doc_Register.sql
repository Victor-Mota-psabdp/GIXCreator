SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_NF_Doc_Register](
	[cd_servico] [int] NOT NULL,
	[Item_lei] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Descricao] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [datetime] NULL,
	[cd_site] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Desativada] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[CNAE] [varchar](25) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
