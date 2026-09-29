SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pedido_Det_Complementar](
	[cd_pedido] [int] NOT NULL,
	[cd_produto] [int] NOT NULL,
	[Item] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Lote] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_ins] [datetime] NULL,
	[cd_pes_fabricante] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[cd_pais_fabricante] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_FOB] [float] NULL,
	[ID_TP_AC] [bigint] NULL,
 CONSTRAINT [PK_Pedido_Det_Complementar] PRIMARY KEY CLUSTERED 
(
	[cd_pedido] ASC,
	[cd_produto] ASC,
	[Item] ASC,
	[Lote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
