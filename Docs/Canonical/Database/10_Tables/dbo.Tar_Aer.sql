SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tar_Aer](
	[TAEID] [int] NOT NULL,
	[TAECdOrg] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TAECdDst] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TAECdVia] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cia_Aer] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TAEDtVal] [datetime] NOT NULL,
	[TAEFreq] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[TAETTime] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[TAETTimeFator] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TAETpFator] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[TAEFator] [float] NULL,
	[TAEObs] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Tptid] [int] NOT NULL,
	[TAEDtAlt] [datetime] NULL,
 CONSTRAINT [PK_Tar_Aer] PRIMARY KEY CLUSTERED 
(
	[TAEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Tar_Aer] UNIQUE NONCLUSTERED 
(
	[TAECdOrg] ASC,
	[TAECdDst] ASC,
	[TAECdVia] ASC,
	[Cd_Cia_Aer] ASC,
	[Tptid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tar_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Tar_Aer_Cia_Aerea] FOREIGN KEY([Cd_Cia_Aer])
REFERENCES [dbo].[Cia_Aerea] ([Cd_Cia_Aer])
GO
ALTER TABLE [dbo].[Tar_Aer] CHECK CONSTRAINT [FK_Tar_Aer_Cia_Aerea]
GO
ALTER TABLE [dbo].[Tar_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Tar_Aer_Localidade] FOREIGN KEY([TAECdOrg])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tar_Aer] CHECK CONSTRAINT [FK_Tar_Aer_Localidade]
GO
ALTER TABLE [dbo].[Tar_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Tar_Aer_Localidade1] FOREIGN KEY([TAECdDst])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tar_Aer] CHECK CONSTRAINT [FK_Tar_Aer_Localidade1]
GO
ALTER TABLE [dbo].[Tar_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Tar_Aer_Localidade2] FOREIGN KEY([TAECdVia])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tar_Aer] CHECK CONSTRAINT [FK_Tar_Aer_Localidade2]
GO
ALTER TABLE [dbo].[Tar_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Tar_Aer_Tipo_Moeda] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Tar_Aer] CHECK CONSTRAINT [FK_Tar_Aer_Tipo_Moeda]
GO
ALTER TABLE [dbo].[Tar_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Tar_Aer_Tipo_Tarifario] FOREIGN KEY([Tptid])
REFERENCES [dbo].[Tipo_Tarifario] ([TptID])
GO
ALTER TABLE [dbo].[Tar_Aer] CHECK CONSTRAINT [FK_Tar_Aer_Tipo_Tarifario]
GO
