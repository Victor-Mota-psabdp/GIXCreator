SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Livro_Contabil_Item](
	[ID] [int] NOT NULL,
	[Item] [int] NOT NULL,
	[Job] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Historico] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Historico2] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Valor] [float] NULL,
	[ContaCredito] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ContaDebito] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Usuario] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Last_UPD] [datetime] NULL,
 CONSTRAINT [PK_Livro_Contabil_Item_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
