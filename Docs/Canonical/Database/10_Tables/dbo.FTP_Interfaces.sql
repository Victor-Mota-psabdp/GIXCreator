SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FTP_Interfaces](
	[ID_FTP] [int] NULL,
	[FTP_Descricao] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[FTP_END] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Usuario] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[Senha] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Pasta_Origem] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Pasta_Lidos] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Host] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Port] [int] NULL,
	[Destination_Folder] [varchar](200) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
