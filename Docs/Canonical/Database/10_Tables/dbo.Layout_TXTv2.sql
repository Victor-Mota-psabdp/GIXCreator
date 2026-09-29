SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Layout_TXTv2](
	[ID_Layout] [int] NOT NULL,
	[Cd_Layout] [int] NOT NULL,
	[ID_Campo] [int] NOT NULL,
	[Campo_Fornecedor] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Indicador] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Posicao] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Tipo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Obs] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Status] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
