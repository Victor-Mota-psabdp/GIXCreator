SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Report_Log](
	[ID_Report] [int] NULL,
	[Cd_Usuario] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[dtInicio] [datetime] NULL,
	[dtFinal] [datetime] NULL,
	[strSQL] [varchar](200) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
