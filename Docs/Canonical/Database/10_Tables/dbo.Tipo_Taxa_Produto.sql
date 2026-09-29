SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Taxa_Produto](
	[Cd_Produto] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Descricao_Produto] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Ativo] [bit] NULL,
	[dt_ins] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
