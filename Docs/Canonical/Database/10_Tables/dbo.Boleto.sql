SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Boleto](
	[cd_boleto] [varchar](8) COLLATE Latin1_General_CI_AI NOT NULL,
	[dv] [int] NULL,
	[Inscricao_Numero] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Agencia_Cedente] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Conta_Cedente] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[cd_pes] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[FatCod] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[dt_Boleto] [datetime] NULL,
	[cd_usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[valor] [decimal](12, 2) NULL,
	[cd_instrucao_01] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[cd_instrucao_02] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[dt_emissao_txt] [datetime] NULL,
	[cd_usuario_emissao_txt] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[arquivo_txt] [varchar](250) COLLATE Latin1_General_CI_AI NULL,
	[cd_banco] [varchar](3) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
