SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pedido_Ship_Container_Backup](
	[cd_pedido] [int] NOT NULL,
	[cd_produto] [int] NOT NULL,
	[Qty] [float] NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Lote] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_ins] [datetime] NULL,
	[Num_Cont] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
 CONSTRAINT [PK_Pedido_Ship_Container_Backup] PRIMARY KEY CLUSTERED 
(
	[cd_pedido] ASC,
	[cd_produto] ASC,
	[Num_Proc] ASC,
	[Item] ASC,
	[Lote] ASC,
	[Num_Cont] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
