SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pedido_Det](
	[Cd_Pedido] [int] NOT NULL,
	[Cd_Produto] [int] NOT NULL,
	[Lote] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Qty] [float] NULL,
	[Vlr_Item] [float] NULL,
	[Peso_Item] [float] NULL,
	[UoM] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Item] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[NCM] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[NATOP] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[UOM_PRC] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[SAP_Company] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Peso_UOM] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Total_Item] [float] NULL,
	[Contract] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Requision] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[PO_GRP] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Finalidade] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Invoice] [float] NULL,
	[Peso_Bruto_TOT] [float] NULL,
	[Peso_Liquido_TOT] [float] NULL,
	[DN_Valida] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[In_Progress] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Requerimento] [nchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Total_Invoice_USD] [float] NULL,
	[Total_Invoice_Local] [float] NULL,
	[UPC] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete] [float] NULL,
	[Qtde_Embal] [int] NULL,
	[cd_tp_embal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Pedido_Det] PRIMARY KEY CLUSTERED 
(
	[Cd_Pedido] ASC,
	[Cd_Produto] ASC,
	[Lote] ASC,
	[Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
