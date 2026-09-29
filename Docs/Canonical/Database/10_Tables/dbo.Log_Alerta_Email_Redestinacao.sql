SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Log_Alerta_Email_Redestinacao](
	[ID_Log] [bigint] IDENTITY(1,1) NOT NULL,
	[Dt_Envio] [datetime] NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Assunto] [varchar](max) COLLATE Latin1_General_CI_AI NOT NULL,
	[Emails] [varchar](max) COLLATE Latin1_General_CI_AI NOT NULL,
	[Mensagem] [varchar](max) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
