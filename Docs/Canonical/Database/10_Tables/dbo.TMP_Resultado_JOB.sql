SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TMP_Resultado_JOB](
	[Consol] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Data_Criacao] [datetime] NULL,
	[ETA] [datetime] NULL,
	[ETD] [datetime] NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[DC] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [char](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Org] [decimal](10, 2) NULL,
	[Credito_CX] [decimal](10, 2) NULL,
	[Credito_EmAberto] [decimal](10, 2) NULL,
	[Debito_CX] [decimal](10, 2) NULL,
	[Debito_EmAberto] [decimal](10, 2) NULL,
	[Vlr_Org_RS] [decimal](10, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
