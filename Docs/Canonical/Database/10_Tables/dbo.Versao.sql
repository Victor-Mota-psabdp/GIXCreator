SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Versao](
	[Cd_Versao] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Pais] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Num_Versao_ATL] [int] NULL,
	[Num_Versao_GeraXLS] [int] NULL,
	[Num_Versao_ReportXLS] [int] NULL,
	[Cd_Moeda_Local] [char](3) COLLATE Latin1_General_CI_AI NULL,
	[Num_Versao_Ler_XML] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
