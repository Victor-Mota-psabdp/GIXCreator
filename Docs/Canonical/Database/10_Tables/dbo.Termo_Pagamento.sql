SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Termo_Pagamento](
	[Cd_Termo] [int] NOT NULL,
	[Descricao_Termo] [nvarchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Dias] [int] NULL,
	[Dt_Base] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Mapa_ATL] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Ativo] [bit] NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Termo_Pagamento] PRIMARY KEY CLUSTERED 
(
	[Cd_Termo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Termo_Pagamento] ADD  DEFAULT (getdate()) FOR [Dt_Ins]
GO
