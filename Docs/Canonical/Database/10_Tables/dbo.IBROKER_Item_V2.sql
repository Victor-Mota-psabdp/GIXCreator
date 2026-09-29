SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IBROKER_Item_V2](
	[ID] [bigint] NOT NULL,
	[ID_Item] [int] NOT NULL,
	[Product_ID] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Qty] [decimal](15, 2) NULL,
	[UOM_Siscomex] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[UOM] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Net_Weight] [decimal](12, 4) NULL,
	[Unit_Price] [decimal](12, 4) NULL,
	[NCM] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ID_RM] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Item] [int] NOT NULL,
	[Num_Pedido] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Full_Description] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_IBROKER_Item_V2] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[ID_Item] ASC,
	[Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
