SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Temp_Contabilidade_Report](
	[Filial] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Data] [datetime] NULL,
	[Conta_Debito] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Conta_Credito] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Valor] [float] NULL,
	[Codigo_Hist] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Hist_1] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Hist_2] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Hist_3] [varchar](600) COLLATE Latin1_General_CI_AI NULL,
	[DC] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Centro_Custo] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[CK] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Num_lcto] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Job] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Taxa] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Apelido] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Regra] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Stored] [varchar](50) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
