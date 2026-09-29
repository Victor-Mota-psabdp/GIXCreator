SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pais_Regiao_SCHNEIDER](
	[Cd_IATA_Pais] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Pais_SCH] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Pais_ATL] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Regiao_Pais] [varchar](10) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
