SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Imprime_BL_Original](
	[num_proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[dt_ins] [datetime] NOT NULL,
	[cd_user] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tipo] [varchar](1) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
