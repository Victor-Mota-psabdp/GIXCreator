SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Pedido_Det_Temp_New](
	[ID] [bigint] NOT NULL,
	[Item] [varchar](200) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pedido] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Produto] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Produto] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Lote] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Qty] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Item] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Item] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[UoM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_UoM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[NCM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[NATOP] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[UOM_PRC] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[SAP_Company] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Peso_UOM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Total_Item] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Contract] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Requision] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[PO_GRP] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Finalidade] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Invoice] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Bruto_TOT] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Liquido_TOT] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[DN_Valida] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[In_Progress] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Requerimento] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Total_Invoice_USD] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Total_Invoice_Local] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[UPC] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Qtde_Embal] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Embal] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Embal] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_House_Temp] [bigint] NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Pedido_Det_Temp_New] ADD [ID_Req] [varchar](200) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Pedido_Det_Temp_New] ADD [Intl_Reference] [varchar](200) COLLATE Latin1_General_CI_AI NULL
 CONSTRAINT [PK_Pedido_Det_Temp_New] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
