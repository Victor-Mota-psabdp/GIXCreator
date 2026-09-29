SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NF_Fatura](
	[ID] [int] NOT NULL,
	[Numero_Fat] [varchar](8) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nota_Fiscal] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Acesso] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Emissao] [datetime] NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_CPF_CNPJ] [varchar](35) COLLATE Latin1_General_CI_AI NULL,
	[Num_RG_IE] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Razao_Social] [varchar](35) COLLATE Latin1_General_CI_AI NULL,
	[Endereco] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Numero] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Bairro] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Cep] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Cidade] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[UF] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Pais] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Serv] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Condicoes] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Prazo] [datetime] NULL,
	[Cd_Status] [int] NOT NULL,
	[Total_NF] [float] NULL,
	[Total_FAT] [float] NOT NULL,
	[Observ_NF] [varchar](5000) COLLATE Latin1_General_CI_AI NULL,
	[Aliq_ISS] [float] NULL,
	[Valor_ISS] [float] NULL,
	[ISS_Retido] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[RPS_Data] [datetime] NULL,
	[RPS_NFE] [varchar](9) COLLATE Latin1_General_CI_AI NULL,
	[RPS_NFE_Verif] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[CdsId] [int] NULL,
	[SitId] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Aliq_ISS_Rps] [decimal](5, 2) NULL,
	[RPS_Envio] [bit] NULL,
	[cd_usuario_cancel] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Habilita_Impostos] [bit] NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Canc] [datetime] NULL,
	[Dt_Cont_Canc] [datetime] NULL,
	[dt_envio_ax] [datetime] NULL,
	[dt_envio_canc_ax] [datetime] NULL,
	[Vencimento] [datetime] NULL,
	[Atencao] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[cd_servico] [bigint] NULL,
	[Item_lei] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CNAE] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Descricao] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[IRRF_Tx] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[FatVendorInvoiceNumber] [varchar](17) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
