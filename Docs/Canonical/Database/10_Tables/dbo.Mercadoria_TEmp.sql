SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Mercadoria_TEmp](
	[NM_UN_MEDID_COMER] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[NR_ADICAO] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[NR_DECLARACAO_IMP] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NR_SEQ_PRODUTO] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[QT_MERC_UN_COMERC] [decimal](10, 2) NULL,
	[Descricao] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[VL_MERC_MOEDA_NEG] [decimal](10, 2) NULL,
	[product_Code] [varchar](50) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
