SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Integracao_ImpXML_Log](
	[ID_Local] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Mensagem] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [char](16) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Arquivo] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Data] [datetime] NULL,
	[Envio] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
