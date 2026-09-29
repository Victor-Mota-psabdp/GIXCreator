SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DI_Item_BR](
	[Num_Proc] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item] [int] NOT NULL,
	[cd_Produto] [int] NULL,
	[PesoLiquido] [decimal](18, 2) NULL,
	[PesoBruto] [decimal](18, 2) NULL,
	[Vlr_Item] [decimal](18, 6) NULL,
	[FOB_USD] [decimal](18, 2) NULL,
	[FOB_Reais] [decimal](18, 2) NULL,
	[Frete_USD] [decimal](18, 2) NULL,
	[Frete_Reais] [decimal](18, 2) NULL,
	[Seguro_USD] [decimal](18, 2) NULL,
	[Seguro_Reais] [decimal](18, 2) NULL,
	[Acrescimos_USD] [decimal](18, 2) NULL,
	[Acrescimos_Reais] [decimal](18, 2) NULL,
	[Aliq_IPI] [decimal](18, 2) NULL,
	[IPI_Reais] [decimal](18, 2) NULL,
	[Aliq_II] [decimal](18, 2) NULL,
	[II_Reais] [decimal](18, 2) NULL,
	[LI_PERIODICIDADE] [int] NULL,
	[Valor_Antidump] [decimal](18, 2) NULL,
	[Quantidade] [decimal](18, 2) NULL,
	[Taxa_siscomex] [decimal](18, 2) NULL,
	[FOB_Moeda] [decimal](18, 2) NULL,
	[Frete_Moeda_Prepaid] [decimal](18, 2) NULL,
	[Frete_Moeda_Collect] [decimal](18, 2) NULL,
	[Frete_Moeda] [decimal](18, 2) NULL,
	[Valor_CIF_Reais] [decimal](18, 2) NULL,
	[Valor_II] [decimal](18, 2) NULL,
	[Valor_IPI] [decimal](18, 2) NULL,
	[Valor_ICMS] [decimal](18, 2) NULL,
	[Valor_PIS] [decimal](18, 2) NULL,
	[Valor_Cofins] [decimal](18, 2) NULL,
	[Dt_Ins] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
