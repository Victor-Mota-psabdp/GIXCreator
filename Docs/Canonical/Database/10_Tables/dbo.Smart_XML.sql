SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Smart_XML](
	[ID_Smart] [bigint] IDENTITY(1,1) NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[XML_DOC] [nvarchar](max) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Arquivo] [varchar](500) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins] [datetime] NOT NULL,
	[Dt_Envio] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
