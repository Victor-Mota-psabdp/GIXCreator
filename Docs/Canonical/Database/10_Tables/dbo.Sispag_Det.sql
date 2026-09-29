SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sispag_Det](
	[Lote] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[LoteSeq] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[segmento] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[tipoMovimento] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Banco] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Agencia] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Conta] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[cd_pes] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[la] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[DT_Pgto] [datetime] NULL,
	[Tipo_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[ValorPgto] [decimal](15, 5) NULL,
	[ItauNumero] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[DT_Efetiva] [datetime] NULL,
	[valorEfetivo] [nchar](10) COLLATE Latin1_General_CI_AI NULL,
	[FinalidadeDetalhe] [varchar](18) COLLATE Latin1_General_CI_AI NULL,
	[NumeroDocumento] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[NumeroInscricao] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[FinalidadeDoc] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[FinalidadeTed] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Aviso] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[OCorrencias] [varchar](50) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
