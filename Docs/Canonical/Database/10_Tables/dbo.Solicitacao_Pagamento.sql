SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Solicitacao_Pagamento](
	[numSol_Pgto] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_solicitante] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_departamento] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[formaPgto] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[moeda] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[valor] [decimal](10, 2) NOT NULL,
	[cd_cliente] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[referente] [varchar](150) COLLATE Latin1_General_CI_AI NOT NULL,
	[observacoes] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[banco] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[agencia] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[contaCorrente] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[cnpj] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[ck_ativo] [bit] NOT NULL,
	[cd_autGerente] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[autorizado] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[num_lcto_div] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[dt_solicitacao] [datetime] NULL,
	[dt_autGerente] [datetime] NULL,
	[dt_autDiretoria] [datetime] NULL,
	[dt_vencimento] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
