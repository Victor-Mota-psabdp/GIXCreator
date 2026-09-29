SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[E_AirFreight_XML](
	[ID_AirFreight] [bigint] IDENTITY(1,1) NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[HAWB_MAWB] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[XML_DOC] [nvarchar](max) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Arquivo] [varchar](500) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Envio] [datetime] NOT NULL,
	[Status_Envio] [varchar](500) COLLATE Latin1_General_CI_AI NOT NULL,
	[XML_DOC_XML_Retorno] [xml] NULL,
	[Dt_Ins_Retorno] [datetime] NULL,
	[XML_DOC_Retorno] [varchar](max) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
