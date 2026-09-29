SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Demurrage_ATL](
	[Processo] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Fatura] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Apelido] [varchar](60) COLLATE Latin1_General_CI_AI NOT NULL,
	[Atracacao] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vencimento] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Valor] [float] NULL,
	[Desconto] [float] NULL,
	[Desc_Obs] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Navio] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[HBL] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[CNPJ] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Tipo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Emis] [datetime] NULL,
	[Paridade] [float] NULL,
	[Garantia] [float] NULL,
	[seq] [int] NULL,
	[ID_Status] [bigint] NULL,
	[dt_alter] [datetime] NULL,
	[dt_envio] [datetime] NULL,
	[cd_pes] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Demurrage] PRIMARY KEY CLUSTERED 
(
	[Processo] ASC,
	[Fatura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
