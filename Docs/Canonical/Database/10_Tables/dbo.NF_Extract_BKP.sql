SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NF_Extract_BKP](
	[ID] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Name] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[JOB_Master] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[IC_Number] [bigint] NULL,
	[Delete_YN] [bit] NULL,
	[delete_Dt] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
