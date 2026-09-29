SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AX_DOC_XML_Oracle](
	[ID_AX] [bigint] NULL,
	[Cancel] [bit] NULL,
	[Dt_Envio] [datetime] NULL,
	[XML_DOC] [xml] NULL,
	[Nome_Arquivo] [varchar](250) COLLATE Latin1_General_CI_AI NULL,
	[Verificado] [bit] NULL,
	[MessageId] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Reenvio] [datetime] NULL,
	[ErrorMessage] [varchar](5000) COLLATE Latin1_General_CI_AI NULL,
	[Retransmitted] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
