SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IBROKER_CAP2_V2](
	[ID] [bigint] NOT NULL,
	[Qty_Item] [int] NULL,
	[Cod_Currency_Order] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Currency_Order] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Order_Value] [decimal](15, 2) NULL,
	[Cod_Currency_Freight] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Currency_Freight] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Freight_Value] [decimal](15, 2) NULL,
	[Freight_Type] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Incoterm] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Incoterm_Descr] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cod_Currency_Invoice] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Currency_Invoice] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Invoice_Value] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_IBROKER_CAP2_V2] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
