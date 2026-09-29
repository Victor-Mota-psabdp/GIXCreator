SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pedido_Temp_New](
	[ID] [bigint] NOT NULL,
	[ID_Batch] [bigint] NULL,
	[Cd_pedido] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_Pedido] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Buyer] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Buyer] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Seller] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Seller] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Incoterm] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Incoterm] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Modal] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Modal] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Moeda] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[vlr_pedido] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Pedido] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[DL_Chegada] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Obs_PC] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes_CTT] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[cd_tp_cont] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tipo] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Tipo] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pais_Org] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Pais_Org] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pais_Dst] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Pais_Dst] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Status] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Status] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_USERID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_USERID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_CSRID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_CSRID] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Grupo] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Grupo] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_PO] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Customer_PO] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Payment] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Order_Type] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consignee] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Consignee] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Selling_SAP] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[PO_Responsible] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Responsible] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Planta] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Status_Entrega] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Pedido_Retorno] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Pedido_Invoice_Only] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Vendor] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[DN_R] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Shipper] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Shipper] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_House_Temp] [bigint] NULL,
	[ID_Req] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Intl_Reference] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Id_TP_House_Temp] [bigint] NULL,
	[SystemCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
 CONSTRAINT [PK_Pedido_Temp_New] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Pedido_Temp_New] ADD  DEFAULT (getdate()) FOR [Dt_Ins]
GO
