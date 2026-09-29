SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Taxario](
	[TxrSeq] [int] IDENTITY(1,1) NOT NULL,
	[Cd_Tp_TX] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Modal] [char](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Local] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TxrNat] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TxrValor] [float] NOT NULL,
	[TxrForma] [varchar](80) COLLATE Latin1_General_CI_AI NOT NULL,
	[TxrValidade] [datetime] NOT NULL,
 CONSTRAINT [PK_Taxario] PRIMARY KEY CLUSTERED 
(
	[TxrSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Taxario] UNIQUE NONCLUSTERED 
(
	[Cd_Tp_TX] ASC,
	[Cd_Modal] ASC,
	[Cd_Local] ASC,
	[TxrNat] ASC,
	[Cd_Pes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Taxario]  WITH NOCHECK ADD  CONSTRAINT [FK_Taxario_Localidade] FOREIGN KEY([Cd_Local])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Taxario] CHECK CONSTRAINT [FK_Taxario_Localidade]
GO
ALTER TABLE [dbo].[Taxario]  WITH NOCHECK ADD  CONSTRAINT [FK_Taxario_Pessoa] FOREIGN KEY([Cd_Pes])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Taxario] CHECK CONSTRAINT [FK_Taxario_Pessoa]
GO
ALTER TABLE [dbo].[Taxario]  WITH CHECK ADD  CONSTRAINT [FK_Taxario_Tipo_Moeda] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Taxario] CHECK CONSTRAINT [FK_Taxario_Tipo_Moeda]
GO
ALTER TABLE [dbo].[Taxario]  WITH CHECK ADD  CONSTRAINT [FK_Taxario_Tipo_Taxa] FOREIGN KEY([Cd_Tp_TX])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Taxario] CHECK CONSTRAINT [FK_Taxario_Tipo_Taxa]
GO
