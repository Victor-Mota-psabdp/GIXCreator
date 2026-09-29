SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Vendas_Fechamento](
	[Cd_Vendedor] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Org] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Fech] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Prop] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Cad] [datetime] NULL,
	[Dt_Perd] [datetime] NULL,
 CONSTRAINT [PK_Vendas_Fechamento] PRIMARY KEY CLUSTERED 
(
	[Cd_Vendedor] ASC,
	[Cd_Pes] ASC,
	[Cd_Org] ASC,
	[Cd_Dst] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
