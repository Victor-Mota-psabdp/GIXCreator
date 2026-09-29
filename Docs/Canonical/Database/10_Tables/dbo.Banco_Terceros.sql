SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Banco_Terceros](
	[cd_Banco] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Banco] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[cod_Banco] [varchar](20) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
