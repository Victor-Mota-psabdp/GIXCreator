SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Percentual_Produto_Hexion](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pedido] [bigint] NOT NULL,
	[Cd_Produto] [bigint] NOT NULL,
	[Item] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Percentual] [float] NULL,
	[Paridade] [float] NULL,
	[Ano] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Percentual_Produto_Hexion] PRIMARY KEY CLUSTERED 
(
	[Num_Proc] ASC,
	[Cd_Pedido] ASC,
	[Cd_Produto] ASC,
	[Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
