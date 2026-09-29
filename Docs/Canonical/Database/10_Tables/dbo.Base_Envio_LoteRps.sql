SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Base_Envio_LoteRps](
	[Numero] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Serie] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Tipo] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[DataEmissao] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[NaturezaOperacao] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[RegimeEspecialTributacao] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[OptanteSimplesNacional] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[IncentivadorCultural] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Status] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[ValorServicos] [decimal](10, 2) NULL,
	[ValorPis] [decimal](10, 2) NULL,
	[ValorCofins] [decimal](10, 2) NULL,
	[ValorInss] [decimal](10, 2) NULL,
	[ValorIr] [decimal](10, 2) NULL,
	[ValorCsll] [decimal](10, 2) NULL,
	[IssRetido] [int] NULL,
	[ValorIssRetido] [decimal](10, 2) NULL,
	[ValorIss] [decimal](10, 2) NULL,
	[BaseCalculo] [decimal](10, 2) NULL,
	[Aliquota] [decimal](10, 2) NULL,
	[ValorLiquidoNfse] [decimal](10, 2) NULL,
	[ItemListaServico] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[CodigoCnae] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[CodigoTributacaoMunicipio] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[CodigoMunicipio] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Discriminacao] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[MunicipioPrestacaoServico] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cnpj] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[InscricaoMunicipal] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[CpfCnpj] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[CpfInscricaoMunicipal] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[RazaoSocial] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[Endereco] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[NumeroEnd] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Complemento] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Bairro] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cidade] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CodigoMunicipioE] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[CodigoMunicipioEnd] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Uf] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Estado] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cep] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Telefone] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Email] [varchar](50) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[Base_Envio_LoteRps] ADD [Ref_Acesso] [varchar](1) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Base_Envio_LoteRps] ADD [ValorCargaTributaria] [decimal](10, 2) NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[Base_Envio_LoteRps] ADD [Pais] [varchar](100) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Base_Envio_LoteRps] ADD [Id_Base_Envio_LoteRps] [int] IDENTITY(1,1) NOT NULL
ALTER TABLE [dbo].[Base_Envio_LoteRps] ADD [Competencia] [varchar](25) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Base_Envio_LoteRps] ADD [CodigoPais] [varchar](5) COLLATE Latin1_General_CI_AI NULL
ALTER TABLE [dbo].[Base_Envio_LoteRps] ADD [ExigibilidadeISS] [varchar](1) COLLATE Latin1_General_CI_AI NULL

GO
SET ANSI_PADDING OFF
GO
