SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Fatura_ARG](
	[ID_Fat] [int] NOT NULL,
	[Numero] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Fatura] [datetime] NOT NULL,
	[Codigo] [varchar](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Razao_Social] [varchar](35) COLLATE Latin1_General_CI_AI NOT NULL,
	[Endereco] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cidade] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Pais] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Condicao_Venda] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Insc_IVA] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[CUIT] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Total] [float] NOT NULL,
	[Total_Iva] [float] NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Status] [varchar](1) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Fatura_ARG] ADD [Obs] [varchar](5000) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Fatura_ARG] ADD [Paridade] [float] NULL
ALTER TABLE [dbo].[Fatura_ARG] ADD [Aliq_ISS] [float] NULL
ALTER TABLE [dbo].[Fatura_ARG] ADD [cd_servico] [bigint] NULL
ALTER TABLE [dbo].[Fatura_ARG] ADD [Item_lei] [varchar](50) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Fatura_ARG] ADD [CNAE] [varchar](25) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Fatura_ARG] ADD [Descricao] [varchar](500) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Fatura_ARG] ADD [IRRF_Tx] [char](1) COLLATE Latin1_General_CI_AI NULL
 CONSTRAINT [PK_Fatura_ARG] PRIMARY KEY CLUSTERED 
(
	[ID_Fat] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Fatura_ARG]  WITH CHECK ADD  CONSTRAINT [FK_Fatura_ARG_Fatura_ARG] FOREIGN KEY([Cd_Pes])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Fatura_ARG] CHECK CONSTRAINT [FK_Fatura_ARG_Fatura_ARG]
GO
