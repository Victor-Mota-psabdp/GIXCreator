SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Custo_Cliente_Temp](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pedido] [int] NOT NULL,
	[Cd_Produto] [int] NOT NULL,
	[Cd_tp_tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Item_Custo] [decimal](10, 2) NULL,
	[Num_NF_Custo] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Prestacao] [char](1) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Custo_Cliente_Temp] PRIMARY KEY CLUSTERED 
(
	[Num_Proc] ASC,
	[Cd_Pedido] ASC,
	[Cd_Produto] ASC,
	[Cd_tp_tx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
