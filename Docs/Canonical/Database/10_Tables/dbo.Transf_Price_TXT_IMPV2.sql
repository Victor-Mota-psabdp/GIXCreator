SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Transf_Price_TXT_IMPV2](
	[ID] [bigint] NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Codigo_Empresa] [varchar](9) COLLATE Latin1_General_CI_AI NULL,
	[Codigo_Filial] [varchar](9) COLLATE Latin1_General_CI_AI NULL,
	[Codigo_Material] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Data_Operação] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Documento] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Numero_Documento] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Item] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[Natureza_Operacao] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Natureza_Estoque] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Quantidade] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[Indicador_Lancamento] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Unidade_Medida] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Codigo_PF_PJ] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Categoria_PF_PJ] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Valor_Custo_Total] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[Valor_Custo_Aduaneiro_Outros] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[Valor_Frete_Internacional] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[Valo_Seguro_Internacional] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[Valor_Imposto_Importacao] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[Utilizacao_SAP] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Divisao] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Numero_DI] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Moeda] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Tranf_PricingV2_TXT] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
