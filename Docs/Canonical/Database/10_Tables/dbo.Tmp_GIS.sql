SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tmp_GIS](
	[TmpMachine] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpNota] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpSite] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpSeq] [int] NOT NULL,
	[TmpCritica] [varchar](200) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
