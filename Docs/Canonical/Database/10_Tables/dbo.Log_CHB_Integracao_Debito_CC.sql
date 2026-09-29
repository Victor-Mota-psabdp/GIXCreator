SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_CHB_Integracao_Debito_CC](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Agencia] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cta_Cte] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Envio] [datetime] NULL,
	[Dt_Leitura] [datetime] NULL,
	[Comentarios] [varchar](200) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Log_CHB_Integracao_Debito_CC] ADD  CONSTRAINT [DF_Log_CHB_Integracao_Debito_CC_Dt_Envio]  DEFAULT (getdate()) FOR [Dt_Envio]
GO
