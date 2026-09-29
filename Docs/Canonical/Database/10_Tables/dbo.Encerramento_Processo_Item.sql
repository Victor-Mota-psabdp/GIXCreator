SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Encerramento_Processo_Item](
	[ID] [int] NULL,
	[Tipo] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Tp_tx] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DC] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Valor] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
