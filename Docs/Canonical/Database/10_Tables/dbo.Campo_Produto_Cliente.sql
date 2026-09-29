SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Campo_Produto_Cliente](
	[cd_prod] [int] NOT NULL,
	[Id_Campo] [int] NOT NULL,
	[Campo_Dados] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Cd_Usuario] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Campo_Produto_Cliente] PRIMARY KEY CLUSTERED 
(
	[cd_prod] ASC,
	[Id_Campo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Campo_Produto_Cliente]  WITH CHECK ADD  CONSTRAINT [FK_Campo_Produto_Cliente_Campo_Produto_Cliente] FOREIGN KEY([cd_prod], [Id_Campo])
REFERENCES [dbo].[Campo_Produto_Cliente] ([cd_prod], [Id_Campo])
GO
ALTER TABLE [dbo].[Campo_Produto_Cliente] CHECK CONSTRAINT [FK_Campo_Produto_Cliente_Campo_Produto_Cliente]
GO
