SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Solicitacao_LI_Produto](
	[Num_Solicitacao] [varchar](13) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Produto] [int] NOT NULL,
	[ID_NCM] [int] NULL,
	[Qty] [float] NULL,
	[Peso_Bruto] [decimal](10, 2) NULL,
	[Peso_Liquido] [decimal](10, 2) NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Preco_Unit] [float] NULL,
 CONSTRAINT [PK_Solicitacao_LI_Produto] PRIMARY KEY CLUSTERED 
(
	[Num_Solicitacao] ASC,
	[Cd_Produto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
