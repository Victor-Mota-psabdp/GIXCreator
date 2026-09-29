SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Custo_Cliente_Arg](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pedido] [int] NOT NULL,
	[Cd_Produto] [int] NOT NULL,
	[Cd_Tp_tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Retencao] [float] NULL,
	[Ganancias] [float] NULL,
	[Tipo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Debito] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[CUIT] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Custo_Cliente_Argentina] PRIMARY KEY CLUSTERED 
(
	[Num_Proc] ASC,
	[Cd_Pedido] ASC,
	[Cd_Produto] ASC,
	[Cd_Tp_tx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Custo_Cliente_Arg]  WITH CHECK ADD  CONSTRAINT [FK_Custo_Cliente_Argentina_Custo_Cliente] FOREIGN KEY([Num_Proc], [Cd_Pedido], [Cd_Produto], [Cd_Tp_tx])
REFERENCES [dbo].[Custo_Cliente] ([Num_Proc], [Cd_Pedido], [Cd_Produto], [Cd_tp_tx])
GO
ALTER TABLE [dbo].[Custo_Cliente_Arg] CHECK CONSTRAINT [FK_Custo_Cliente_Argentina_Custo_Cliente]
GO
