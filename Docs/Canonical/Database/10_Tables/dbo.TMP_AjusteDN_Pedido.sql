SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TMP_AjusteDN_Pedido](
	[Num_Pedido_INV] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item] [varchar](4) COLLATE Latin1_General_CI_AI NOT NULL,
	[Lote] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Valor] [decimal](18, 2) NULL,
	[Qty] [float] NULL,
	[Uom_Qty] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Bruto] [decimal](18, 2) NULL,
	[Peso_Liquido] [decimal](18, 2) NULL,
	[Uom_Peso] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Prod_Cliente] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_TMP_AjusteDN_Pedido] PRIMARY KEY CLUSTERED 
(
	[Num_Pedido_INV] ASC,
	[Item] ASC,
	[Lote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
