SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sispag](
	[Lote] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_banco] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[TipoOperacao] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[TipoPagamento] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[FormaPagamento] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[LayoutLote] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Empresa_Inscricao] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Inscricao_Numero] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Id_Lancamento] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Agencia] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Conta] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[cd_pes] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[LoteFinalidade] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[HistoricodeCC] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Ocorrencias] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[dt_Sispag] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
