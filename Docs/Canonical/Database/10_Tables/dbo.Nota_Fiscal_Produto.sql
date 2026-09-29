SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Nota_Fiscal_Produto](
	[ID_NF] [int] NOT NULL,
	[CNPJ] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Cliente] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Fornecedor] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_NF] [datetime] NULL,
	[Enviado] [char](1) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Nota_Fiscal_Produto] PRIMARY KEY CLUSTERED 
(
	[ID_NF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Nota_Fiscal_Produto]  WITH CHECK ADD  CONSTRAINT [FK_Nota_Fiscal_Produto_Pessoa] FOREIGN KEY([Cd_Cliente])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Nota_Fiscal_Produto] CHECK CONSTRAINT [FK_Nota_Fiscal_Produto_Pessoa]
GO
