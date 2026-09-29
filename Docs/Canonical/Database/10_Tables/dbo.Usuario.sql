SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Usuario](
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Usuario] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Senha] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Area] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cargo] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Idioma] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Email] [varchar](40) COLLATE Latin1_General_CI_AI NOT NULL,
	[Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ck_Ativo] [bit] NOT NULL,
	[Fone] [varchar](18) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Nivel] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[ADUserName] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[ADDomain] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Updated_Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Cd_Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Usuario] ADD  DEFAULT ('OUTROS') FOR [Grupo]
GO
ALTER TABLE [dbo].[Usuario] ADD  DEFAULT (1) FOR [Ck_Ativo]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_Fone]  DEFAULT ('(11) 5504-3400') FOR [Fone]
GO
ALTER TABLE [dbo].[Usuario] ADD  DEFAULT (getdate()) FOR [Updated_Date]
GO
