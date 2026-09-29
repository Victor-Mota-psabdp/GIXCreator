SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Solicitacao_LI_Log](
	[Num_Solicitacao] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Oper] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Alteracao] [datetime] NULL,
	[Dt_Envio] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
