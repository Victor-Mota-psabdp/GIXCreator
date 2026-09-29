SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Boleto_Instrucao_Cobranca](
	[cd_instrucao] [char](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[nome_instrucao] [varchar](100) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Banco] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Ativo] [bit] NULL,
	[Dt_Ins] [datetime] NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
