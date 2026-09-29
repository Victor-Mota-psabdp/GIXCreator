SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Schneider_TCT_TESTE_GNC](
	[hsgprocesso] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[hsgseq] [int] NOT NULL,
	[ID_NC] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[cd_nc] [varchar](40) COLLATE Latin1_General_CI_AI NOT NULL,
	[parte_resp] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[historico] [varchar](2000) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
