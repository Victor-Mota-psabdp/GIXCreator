SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Retorno](
	[Arquivo_Ret] [varchar](25) COLLATE Latin1_General_CI_AI NOT NULL,
	[Arquivo_Proc] [varchar](25) COLLATE Latin1_General_CI_AI NOT NULL,
	[Data_Leitura] [datetime] NOT NULL,
	[Data_Retorno] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
