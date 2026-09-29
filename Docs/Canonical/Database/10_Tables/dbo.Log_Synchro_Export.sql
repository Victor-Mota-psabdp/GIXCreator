SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Synchro_Export](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Mensagem] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Dt_envio] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
