SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Nota_Cliente](
	[ID_NF] [bigint] NULL,
	[CNPJ] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Nota_Fiscal] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Emissao] [datetime] NULL,
	[CFOP] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Invoice] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Exportador] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_NF] [float] NULL,
	[CD_Cliente] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Complementar] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[ID_NF_FK] [int] NULL,
	[DI] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Data_DI] [datetime] NULL,
	[Paridade] [float] NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Custo] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Envio] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[data_envio] [datetime] NULL,
	[Mensagem_Erro] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[CNPJ_Destinatario] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Serie] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[IntNLog] [int] NULL,
	[IntNAleatorio] [int] NULL,
	[intDigitoControle] [int] NULL,
	[Cd_IBGE_Municipio_Gerador] [int] NULL,
	[Cd_IBGE_Municipio_Emitente] [int] NULL,
	[Cd_IBGE_Municipio_Destinatario] [int] NULL,
	[Cd_Pais_BACEN] [int] NULL,
	[Vlr_Tot_Base_ICMS] [decimal](15, 2) NULL,
	[Vlr_Tot_ICMS] [decimal](15, 2) NULL,
	[Vlr_Tot_Base_ICMS_ST] [decimal](15, 2) NULL,
	[Vlr_Tot_ICMS_ST] [decimal](15, 2) NULL,
	[Vlr_Tot_Prod_Serv] [decimal](15, 2) NULL,
	[Vlr_Tot_Frete] [decimal](15, 2) NULL,
	[Vlr_Tot_Seguro] [decimal](15, 2) NULL,
	[Vlr_Tot_Desconto] [decimal](15, 2) NULL,
	[Vlr_Tot_IPI] [decimal](15, 2) NULL,
	[Vlr_Tot_PIS] [decimal](15, 2) NULL,
	[Vlr_Tot_Cofins] [decimal](15, 2) NULL,
	[Vlr_Tot_Outras_Desp] [decimal](15, 2) NULL,
	[Cd_Transp] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Info_Complementar] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Envio_RM] [datetime] NULL,
	[dt_ins_nc] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Nota_Cliente] ADD  DEFAULT (getdate()) FOR [dt_ins_nc]
GO
