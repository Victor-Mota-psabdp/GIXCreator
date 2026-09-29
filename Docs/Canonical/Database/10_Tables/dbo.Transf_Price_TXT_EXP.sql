SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Transf_Price_TXT_EXP](
	[ID] [bigint] NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Codigo_Empresa] [varchar](9) COLLATE Latin1_General_CI_AI NULL,
	[Codigo_Filial] [varchar](9) COLLATE Latin1_General_CI_AI NULL,
	[Serie_Nota_Fiscal] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Numero_Nota_Fiscal] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Data_Emissao] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Numero_RE] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Codigo_Produto] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tipo_Conhecimento_Transporte] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Relacionamento] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Data_RE] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Declaracao_Exportacao] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Data_Declaracao_Exportacao] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Status_Averbacao] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Conhecimento_Embarque] [varchar](18) COLLATE Latin1_General_CI_AI NULL,
	[Data_Conhecimento_Embarque] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Codigo_Pais] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Comprovante_Exportacao] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Data_Comprovante_Exportacao] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Modelo_de_documento] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Natureza_Exportacao] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Data_Averbacao_DE] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Declaracao] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Chave_NFe] [varchar](44) COLLATE Latin1_General_CI_AI NULL,
	[Moeda] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[OpenFlex_01] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[OpenFlex_02] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[OpenFlex_03] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[OpenFlex_04] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[OpenFlex_05] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[OpenFlex_06] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[OpenFlex_07] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[OpenFlex_08] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Transf_Price_TXT_EXP] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[Numero_RE] ASC,
	[Codigo_Produto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
