SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pedido_Temp](
	[Cd_pedido] [int] NOT NULL,
	[Num_Pedido] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Buyer] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Seller] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Incoterm] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[cd_modal] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[cd_tp_moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[vlr_pedido] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Pedido] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DL_Chegada] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Obs_PC] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes_CTT] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[cd_tp_cont] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_tipo] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pais_Org] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pais_Dst] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Status] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_USERID] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Cd_CSRID] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_PO] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Customer_PO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Payment] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Order_Type] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consignee] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Selling_SAP] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[PO_Responsible] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Planta] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Status_Entrega] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Pedido_Retorno] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Pedido_Invoice_Only] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Vendor] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[DN_R] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Porto_Dst] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Porto_Org] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Agente] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Navio] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Container] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Num_Container] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DL_Carga] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DL_Draft] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ETD] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ETA] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Produto] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Aduana_Saida] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Qty] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Liquido_TOT] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Proc_Cliente] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Item] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Item] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete_Item] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Total_Item] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Insert] [datetime] NOT NULL,
	[ID_Tp_Int] [bigint] NOT NULL,
	[Dt_Leitura] [datetime] NULL,
	[Erro] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Pedido_Temp] PRIMARY KEY CLUSTERED 
(
	[Cd_pedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vendor Code - for Dow Process only' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Pedido_Temp', @level2type=N'COLUMN',@level2name=N'Cd_Vendor'
GO
