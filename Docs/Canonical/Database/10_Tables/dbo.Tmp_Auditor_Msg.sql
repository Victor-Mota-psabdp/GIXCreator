SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tmp_Auditor_Msg](
	[TmpMachine] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpProcesso] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[TmpMensagem] [varchar](100) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
