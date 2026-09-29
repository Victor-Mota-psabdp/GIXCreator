SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_TransfereOrdem](
	[Data_add] [datetime] NULL,
	[cd_usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Job] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[SelJob] [varchar](16) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
