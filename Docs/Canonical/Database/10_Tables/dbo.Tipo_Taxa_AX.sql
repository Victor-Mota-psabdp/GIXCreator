SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Taxa_AX](
	[Cd_Charge_AX] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[Descricao_Ingles] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CC_Custo] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[CC_Receita] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Descricao_Local] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CD_Charge_AX_PT] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Codigo_Imposto] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Codidgo_Imposto_Venda] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Tipo_Taxa_AX] PRIMARY KEY CLUSTERED 
(
	[Cd_Charge_AX] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
