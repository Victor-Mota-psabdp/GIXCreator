SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[JOB_HBO](
	[Num_Proc_HBO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins] [datetime] NULL,
	[cd_usuario] [varchar](20) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
