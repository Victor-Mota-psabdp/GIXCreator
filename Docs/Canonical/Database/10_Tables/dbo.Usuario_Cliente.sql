SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Usuario_Cliente](
	[Cd_Usuario] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cliente] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Usuario] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Email] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Ativo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Plasticos] [varchar](29) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [datetime] NULL,
 CONSTRAINT [PK_Usuario_Cliente] PRIMARY KEY CLUSTERED 
(
	[Cd_Usuario] ASC,
	[Cd_Cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
