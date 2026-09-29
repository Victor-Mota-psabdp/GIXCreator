SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpCustomer_profile](
	[ID_CP] [int] NOT NULL,
	[Cd_Cliente] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Modal] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Data] [datetime] NOT NULL,
	[Cd_Org] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Agente] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_SubAgente] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Vendedor] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Vencimento] [datetime] NOT NULL,
	[Campo_Obs] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Prazo] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dias] [int] NULL,
	[Cd_Tipo_Servico] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Contato] [varchar](120) COLLATE Latin1_General_CI_AI NULL,
	[Mercadoria] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[Peso_TN] [float] NULL,
	[Peso_CM3_M3] [float] NULL,
	[Tipo_Carga] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Venda] [decimal](10, 2) NULL,
	[ID_Status_CP] [int] NULL,
	[ID_Registro] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
