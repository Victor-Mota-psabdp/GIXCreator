SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_ATL](
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Host] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Start] [datetime] NULL,
	[Closed] [datetime] NULL,
	[Origem] [varchar](10) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
