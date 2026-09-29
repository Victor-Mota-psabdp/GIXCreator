SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Base_Nota_Fiscal](
	[Nota_Fiscal] [varchar](8) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ref_Acesso] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Emissao] [datetime] NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tipo_Serv] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Condicoes] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Prazo] [datetime] NULL,
	[Cd_Status] [int] NOT NULL,
	[Valor_Total] [decimal](18, 2) NOT NULL,
	[Observ_NF] [varchar](5000) COLLATE Latin1_General_CI_AI NULL,
	[Aliq_ISS] [decimal](18, 2) NULL,
	[Valor_ISS] [decimal](18, 2) NULL,
	[ISS_Retido] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[RPS_Data] [datetime] NULL,
	[RPS_NFE] [varchar](9) COLLATE Latin1_General_CI_AI NULL,
	[RPS_NFE_Verif] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[CdsId] [int] NULL,
	[SitId] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Aliq_ISS_Rps] [decimal](5, 2) NULL,
	[RPS_Envio] [bit] NOT NULL,
	[dt_Cancel] [datetime] NULL,
	[cd_usuario_cancel] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Habilita_Impostos] [bit] NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[cd_servico] [bigint] NULL,
	[Item_lei] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CNAE] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Descricao] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[dt_Protocolo] [datetime] NULL,
	[protocolo] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[dt_Cancel_Prefeitura] [datetime] NULL,
	[IRRF_Tx] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Id_Base_Nota_Fiscal] [int] IDENTITY(1,1) NOT NULL,
	[RPS_ID] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Base_Nota_Fiscal] PRIMARY KEY CLUSTERED 
(
	[Nota_Fiscal] ASC,
	[Ref_Acesso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20230613-153509] ON [dbo].[Base_Nota_Fiscal]
(
	[Id_Base_Nota_Fiscal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Base_Nota_Fiscal] ADD  CONSTRAINT [DF_Base_Nota_Fiscal_RPS_Envio]  DEFAULT ((0)) FOR [RPS_Envio]
GO
