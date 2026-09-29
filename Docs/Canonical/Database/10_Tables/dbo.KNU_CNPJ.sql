SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KNU_CNPJ](
	[Num_CNPJ] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Atividade_Economica] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[CEP] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Bairro] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Complemento] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[IE] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Endereco] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Municipio] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Numero] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Razao] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[UF] [varchar](40) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
