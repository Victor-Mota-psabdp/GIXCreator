SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Report_ABS](
	[JOB] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[DtCriacao] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Grupo] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CredorDevedor] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[BDP_Charge] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Moeda] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DC] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Valor] [decimal](18, 2) NULL,
	[ValorReais] [decimal](18, 2) NULL,
	[Entrada] [decimal](18, 2) NULL,
	[EntradaAberto] [decimal](18, 2) NULL,
	[Saida] [decimal](18, 2) NULL,
	[SaidaAberto] [decimal](18, 2) NULL,
	[Servico] [decimal](18, 2) NULL,
	[ServicoAberto] [decimal](18, 2) NULL,
	[Custo] [decimal](18, 2) NULL,
	[CustoAberto] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
