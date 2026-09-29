SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Registro_Financeiro](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[NUM_CNPJ] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Mes] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[Num_Registro] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tipo_Lanc] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Dt_Venc] [datetime] NULL,
	[Isento] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [char](3) COLLATE Latin1_General_CI_AI NULL,
	[Par_Moeda] [float] NULL,
	[Cd_Regra] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Fatura] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Doc] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Doc_Number] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[Total] [decimal](10, 2) NULL,
	[IVA_Retencoes] [decimal](10, 2) NULL,
	[Total_Doc] [decimal](10, 2) NULL,
	[Cd_Pes_Seguro] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NUM_CNPJ_Seguro] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[ativo] [bit] NULL,
	[Valor_Total_Moeda_Local] [float] NULL,
	[Habilita_Impostos] [bit] NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Registro_Financeiro] ADD [Ref_Acesso] [char](1) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Registro_Financeiro] ADD [cd_servico] [int] NULL
ALTER TABLE [dbo].[Registro_Financeiro] ADD [Item_lei] [varchar](50) COLLATE Latin1_General_CI_AI NULL
 CONSTRAINT [PK_Registro_Financeiro] PRIMARY KEY CLUSTERED 
(
	[Mes] ASC,
	[Ano] ASC,
	[Num_Registro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
