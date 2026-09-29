SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[rentabilidade_processo_temp](
	[Job] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cliente] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Grupo] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Modal] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Mes] [int] NULL,
	[Ano] [int] NULL,
	[Produto] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Job_Status] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Custos_OPER] [decimal](18, 2) NULL,
	[Receita_OPER] [decimal](18, 2) NULL,
	[Custos_Contabil] [decimal](18, 2) NULL,
	[Receita_Contabil] [decimal](18, 2) NULL,
	[Data] [datetime] NULL,
	[Consolidada] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Receita_Demurrage] [decimal](18, 2) NULL,
 CONSTRAINT [PK_rentabilidade_processo_temp] PRIMARY KEY CLUSTERED 
(
	[Job] ASC,
	[Produto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
