SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Solicitacao_LI](
	[Num_Solicitacao] [varchar](13) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Solicitacao] [datetime] NULL,
	[ID_Tipo_LI] [int] NULL,
	[Cd_Usuario_Req] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Usuario_Oper] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_LI] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_LI] [datetime] NULL,
	[Dt_Aut_Embarque] [datetime] NULL,
	[Dt_Deferimento] [datetime] NULL,
	[Dt_Vencimento] [datetime] NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Protocolo_Transmissao] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Motivo] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Obs_LI] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Fabricante] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[ID_Status] [int] NULL,
	[Dt_Requerimento] [datetime] NULL,
	[Num_Requerimento] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CobrancaCliente] [bit] NULL,
	[ID_Regime] [int] NULL,
	[cd_grupo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Solicitacao_LI] PRIMARY KEY CLUSTERED 
(
	[Num_Solicitacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
