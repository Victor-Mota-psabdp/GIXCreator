SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_FComex](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Origem] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Message] [varchar](max) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
