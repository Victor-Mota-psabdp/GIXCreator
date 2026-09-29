SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Nota_Fiscal_Cliente_Det](
	[ID_Item] [int] NOT NULL,
	[ID_NF] [bigint] NULL,
	[Cd_Cliente] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pedido] [int] NOT NULL,
	[Cd_Produto] [int] NOT NULL,
	[NCM] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Quantidade] [float] NULL,
	[Vlr_Item] [float] NULL,
	[Vlr_Total_Item] [float] NULL,
	[Vlr_Frete] [float] NULL,
	[Vlr_Seguro] [float] NULL,
	[Vlr_Siscomex] [float] NULL,
	[Vlr_Outras_Despesas] [float] NULL,
	[ALIQ_II] [float] NULL,
	[VL_BASE_II] [float] NULL,
	[VL_II] [float] NULL,
	[ALIQ_IPI] [float] NULL,
	[VL_BASE_IPI] [float] NULL,
	[VL_TRIBUTAVEL_IPI] [float] NULL,
	[VL_IPI] [float] NULL,
	[VL_ALIQ_PIS] [float] NULL,
	[VL_BASE_PIS] [float] NULL,
	[VL_IMPOSTO_PIS] [float] NULL,
	[VL_ALIQ_COFINS] [float] NULL,
	[VL_BASE_COFINS] [float] NULL,
	[VL_IMPOSTO_COFINS] [float] NULL,
	[ALIQ_ICMS] [float] NULL,
	[VL_BASE_ICMS] [float] NULL,
	[VL_ICMS] [float] NULL,
	[VL_TRIBUTAVEL_ICMS] [float] NULL,
	[Vlr_Total_NF] [float] NULL,
	[Peso_Bruto] [float] NULL,
	[Peso_Liquido] [float] NULL,
	[SITT] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[UoM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Desconto] [decimal](15, 2) NULL,
	[ACRESCIMOS] [float] NULL,
	[CIF] [float] NULL,
	[FOB] [float] NULL,
	[FreteCollect] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20230610-142639] ON [dbo].[Nota_Fiscal_Cliente_Det]
(
	[ID_NF] ASC,
	[Cd_Cliente] ASC
)
INCLUDE([Cd_Produto],[Peso_Bruto],[Peso_Liquido]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
