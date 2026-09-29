SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Custo_Contabilidade](
	[Data] [datetime] NULL,
	[Descricao] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Valor] [decimal](18, 0) NULL,
	[Num_Proc] [varchar](20) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
