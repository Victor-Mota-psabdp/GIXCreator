SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TEMP_ResuladoJob](
	[Consolidada] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Taxa] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_tp_Moeda] [char](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Moeda_Forte] [decimal](10, 2) NULL,
	[DC] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_NF] [decimal](10, 2) NULL,
	[Vlr_Caixa] [decimal](10, 2) NULL,
	[Vlr_BDPCharges] [decimal](10, 2) NULL,
	[Valor_Contabil] [decimal](10, 2) NULL,
	[Num_NF] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Tipo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Em_Aberto] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
