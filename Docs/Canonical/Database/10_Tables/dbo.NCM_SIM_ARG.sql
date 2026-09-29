SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NCM_SIM_ARG](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[NCM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Valor_FOB] [float] NULL,
	[Preco_Unit] [float] NULL,
	[Paridade] [float] NULL,
	[Base_IVA] [float] NULL,
	[Ajuste] [float] NULL,
	[Insumos_Temporaria] [float] NULL,
	[Valor_Reintegro] [float] NULL,
	[Valor_Aduaneiro] [float] NULL,
	[Quantidade] [float] NULL,
	[UoM] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[GMID] [nchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Insumos_Import] [float] NULL,
	[Valor_Frete] [float] NULL,
	[Valor_Seguro] [float] NULL,
	[Valor_Fatura] [float] NULL,
 CONSTRAINT [PK_NCM_SIM_ARG] PRIMARY KEY CLUSTERED 
(
	[Num_Proc] ASC,
	[Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
