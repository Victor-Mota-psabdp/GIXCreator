SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AX_DOC_XML](
	[ID_AX] [bigint] NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Cd_tp_Tx_ATL] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[DC] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Cancel] [bit] NULL,
	[Dt_Envio] [datetime] NULL,
	[XML_DOC] [xml] NULL,
	[Nome_Arquivo] [varchar](75) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
