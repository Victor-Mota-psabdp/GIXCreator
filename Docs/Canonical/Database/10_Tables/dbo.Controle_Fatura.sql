SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Controle_Fatura](
	[cd_controlefatura] [varchar](11) COLLATE Latin1_General_CI_AI NOT NULL,
	[dt_rcto_fatura] [datetime] NULL,
	[dt_envio_cliente] [datetime] NULL,
	[valor] [decimal](10, 2) NULL,
	[cd_tp_moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[paridade] [decimal](10, 2) NULL,
	[valor_brl] [decimal](10, 2) NULL,
	[responsabilidade_bdp] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[periodo] [int] NULL,
	[periodo_bdp] [int] NULL,
	[contato_cliente] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[analise] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[cd_tipo] [int] NULL,
	[cd_fornecedor] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[num_fatura] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[dt_vcto_fatura] [datetime] NULL,
	[num_proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[periodo_inicial] [datetime] NULL,
	[periodo_final] [datetime] NULL,
	[dt_creacao] [datetime] NULL,
	[cd_usuario] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[cd_protocolo] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[cd_reason] [varchar](25) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
