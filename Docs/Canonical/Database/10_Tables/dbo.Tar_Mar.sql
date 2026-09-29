SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tar_Mar](
	[TAMID] [int] NOT NULL,
	[TAMCdOrg] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TAMCdDst] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TAMCdVia] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Armador] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TAMDtVal] [datetime] NOT NULL,
	[TAMFreq] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[TAMTTime] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[TAMTTimeFator] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TAMTpFator] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[TAMFator] [float] NULL,
	[TAMObs] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[TptID] [int] NOT NULL,
	[TAMDtAlt] [datetime] NULL,
 CONSTRAINT [PK_Tar_Mar] PRIMARY KEY CLUSTERED 
(
	[TAMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Tar_Mar] UNIQUE NONCLUSTERED 
(
	[TAMCdOrg] ASC,
	[TAMCdDst] ASC,
	[TAMCdVia] ASC,
	[Cd_Armador] ASC,
	[TptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tar_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Tar_Mar_Armador] FOREIGN KEY([Cd_Armador])
REFERENCES [dbo].[Armador] ([Cd_Armador])
GO
ALTER TABLE [dbo].[Tar_Mar] CHECK CONSTRAINT [FK_Tar_Mar_Armador]
GO
ALTER TABLE [dbo].[Tar_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Tar_Mar_Localidade] FOREIGN KEY([TAMCdOrg])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tar_Mar] CHECK CONSTRAINT [FK_Tar_Mar_Localidade]
GO
ALTER TABLE [dbo].[Tar_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Tar_Mar_Localidade1] FOREIGN KEY([TAMCdDst])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tar_Mar] CHECK CONSTRAINT [FK_Tar_Mar_Localidade1]
GO
ALTER TABLE [dbo].[Tar_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Tar_Mar_Localidade2] FOREIGN KEY([TAMCdVia])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tar_Mar] CHECK CONSTRAINT [FK_Tar_Mar_Localidade2]
GO
ALTER TABLE [dbo].[Tar_Mar]  WITH CHECK ADD  CONSTRAINT [FK_Tar_Mar_Tipo_Moeda] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Tar_Mar] CHECK CONSTRAINT [FK_Tar_Mar_Tipo_Moeda]
GO
ALTER TABLE [dbo].[Tar_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Tar_Mar_Tipo_Tarifario] FOREIGN KEY([TptID])
REFERENCES [dbo].[Tipo_Tarifario] ([TptID])
GO
ALTER TABLE [dbo].[Tar_Mar] CHECK CONSTRAINT [FK_Tar_Mar_Tipo_Tarifario]
GO
