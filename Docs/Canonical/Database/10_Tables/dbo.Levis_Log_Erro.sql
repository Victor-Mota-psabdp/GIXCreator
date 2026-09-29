SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Levis_Log_Erro](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Erro] [datetime] NULL,
	[Dt_Solucao] [datetime] NULL,
	[Mensagem] [varchar](2000) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
