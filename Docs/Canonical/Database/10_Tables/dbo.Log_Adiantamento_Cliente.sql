SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Adiantamento_Cliente](
	[Data_add] [datetime] NULL,
	[cd_usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[tp_oper_add] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[ID] [int] NULL,
	[Job] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[POC] [varchar](5) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
