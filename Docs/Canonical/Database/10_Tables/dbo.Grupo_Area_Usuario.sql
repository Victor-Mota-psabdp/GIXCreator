SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Grupo_Area_Usuario](
	[Cd_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Area] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
 CONSTRAINT [PK_Grupo_Area_Usuario_1] PRIMARY KEY CLUSTERED 
(
	[Cd_Pes_Grupo] ASC,
	[Cd_Area] ASC,
	[Cd_Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Grupo_Area_Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Grupo_Area_Usuario_Area] FOREIGN KEY([Cd_Area])
REFERENCES [dbo].[Area] ([Cd_Area])
GO
ALTER TABLE [dbo].[Grupo_Area_Usuario] CHECK CONSTRAINT [FK_Grupo_Area_Usuario_Area]
GO
ALTER TABLE [dbo].[Grupo_Area_Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Grupo_Area_Usuario_Usuario] FOREIGN KEY([Cd_Usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
ALTER TABLE [dbo].[Grupo_Area_Usuario] CHECK CONSTRAINT [FK_Grupo_Area_Usuario_Usuario]
GO
