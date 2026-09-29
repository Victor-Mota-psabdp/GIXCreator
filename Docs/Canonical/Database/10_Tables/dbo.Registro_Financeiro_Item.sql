SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Registro_Financeiro_Item](
	[Mes] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[Num_Registro] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Id_Item] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Valor] [float] NULL,
	[Cd_Cta_Ctb] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Tx] [char](3) COLLATE Latin1_General_CI_AI NULL,
	[DC] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Valor_IVA] [float] NULL,
	[Valor_Total] [float] NULL,
	[Valor_Total_Moeda_Local] [float] NULL,
 CONSTRAINT [PK_Registro_Financeiro_Item] PRIMARY KEY CLUSTERED 
(
	[Mes] ASC,
	[Ano] ASC,
	[Num_Registro] ASC,
	[Id_Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
