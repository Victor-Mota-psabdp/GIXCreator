SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pedido](
	[Cd_pedido] [int] NOT NULL,
	[Num_Pedido] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Buyer] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Seller] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Incoterm] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[cd_modal] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[cd_tp_moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[vlr_pedido] [float] NULL,
	[Dt_Pedido] [datetime] NULL,
	[DL_Chegada] [datetime] NULL,
	[Obs_PC] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes_CTT] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[cd_tp_cont] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_tipo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pais_Org] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pais_Dst] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Status] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_USERID] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Cd_CSRID] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_PO] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Customer_PO] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Payment] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Order_Type] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consignee] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Selling_SAP] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[PO_Responsible] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Planta] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Status_Entrega] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Pedido_Retorno] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Pedido_Invoice_Only] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Vendor] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[DN_R] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Shipper] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Pedido] PRIMARY KEY CLUSTERED 
(
	[Cd_pedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Pedido] ON [dbo].[Pedido]
(
	[Cd_pedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vendor Code - for Dow Process only' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Pedido', @level2type=N'COLUMN',@level2name=N'Cd_Vendor'
GO
