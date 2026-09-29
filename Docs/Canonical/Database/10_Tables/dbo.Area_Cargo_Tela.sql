SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Area_Cargo_Tela](
	[Cd_Area] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cargo] [int] NOT NULL,
	[Cd_Tela] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
 CONSTRAINT [PK_Area_Cargo_Tela] PRIMARY KEY CLUSTERED 
(
	[Cd_Area] ASC,
	[Cd_Cargo] ASC,
	[Cd_Tela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Area_Cargo_Tela]  WITH CHECK ADD  CONSTRAINT [FK_Area_Cargo_Tela_Area] FOREIGN KEY([Cd_Area])
REFERENCES [dbo].[Area] ([Cd_Area])
GO
ALTER TABLE [dbo].[Area_Cargo_Tela] CHECK CONSTRAINT [FK_Area_Cargo_Tela_Area]
GO
ALTER TABLE [dbo].[Area_Cargo_Tela]  WITH CHECK ADD  CONSTRAINT [FK_Area_Cargo_Tela_Cargo] FOREIGN KEY([Cd_Cargo])
REFERENCES [dbo].[Cargo] ([Cd_Cargo])
GO
ALTER TABLE [dbo].[Area_Cargo_Tela] CHECK CONSTRAINT [FK_Area_Cargo_Tela_Cargo]
GO
ALTER TABLE [dbo].[Area_Cargo_Tela]  WITH CHECK ADD  CONSTRAINT [FK_Area_Cargo_Tela_Tela] FOREIGN KEY([Cd_Tela])
REFERENCES [dbo].[Tela] ([Cd_Tela])
GO
ALTER TABLE [dbo].[Area_Cargo_Tela] CHECK CONSTRAINT [FK_Area_Cargo_Tela_Tela]
GO
