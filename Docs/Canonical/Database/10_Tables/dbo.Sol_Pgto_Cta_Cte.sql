SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sol_Pgto_Cta_Cte](
	[ID] [bigint] NOT NULL,
	[Cd_Cred_Dev] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Pgto_Rcto] [datetime] NOT NULL,
	[Vlr_Doc] [decimal](18, 2) NOT NULL,
	[Dt_Vcto] [datetime] NOT NULL,
	[Cd_Tp_Doc] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Solicitante] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Gerente] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Diretor] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NOT NULL,
	[Status] [bit] NULL,
	[Status_Aprovacao] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Aprovacao] [datetime] NULL,
	[Doc_Register] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Mes] [int] NULL,
	[Ano] [int] NULL,
	[Num_Registro] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Dt_IssueDate] [datetime] NULL,
	[Cd_Tipo_Lanc] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Isento] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [char](3) COLLATE Latin1_General_CI_AI NULL,
	[Par_Moeda] [float] NULL,
	[Cd_Regra] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Fatura] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Doc_RF] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Doc_Number] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[Total] [decimal](10, 2) NULL,
	[IVA_Retencoes] [decimal](10, 2) NULL,
	[Total_Doc] [decimal](10, 2) NULL,
	[Cd_Pes_Seguro] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[NUM_CNPJ_Seguro] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Valor_Total_Moeda_Local] [float] NULL,
	[Habilita_Impostos] [bit] NULL,
	[Ref_Acesso] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[cd_servico] [int] NULL,
	[Item_lei] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[InfBanco] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Sol_Pgto_Cta_Cte] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
