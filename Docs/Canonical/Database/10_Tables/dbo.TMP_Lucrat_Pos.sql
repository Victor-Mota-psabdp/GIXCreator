SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TMP_Lucrat_Pos](
	[StrMachine] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Pos] [int] NOT NULL,
	[Cliente] [varchar](60) COLLATE Latin1_General_CI_AI NOT NULL,
	[Resultado] [float] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
