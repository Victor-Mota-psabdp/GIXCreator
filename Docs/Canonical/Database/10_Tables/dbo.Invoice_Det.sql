SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Invoice_Det](
	[ID_Inv] [int] NOT NULL,
	[Cd_Pedido] [int] NOT NULL,
	[Item] [int] NULL,
	[Cd_Produto] [int] NOT NULL,
	[Quantidade] [int] NULL,
	[Peso_Liquido] [float] NULL,
	[Peso_Bruto] [float] NULL,
	[Preco_Unit] [float] NULL,
	[Cd_Embalagem] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Capacidade] [float] NULL,
	[Tipo_Unid] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Incluso] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Descr_Adicional] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[NF] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[dtNF] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
