SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Proposta_Rot_Aer](
	[PROCOD] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRAID] [int] NOT NULL,
	[PRAOrg] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRADst] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRAGat] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TptID] [int] NOT NULL,
	[PRAFreq] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRATTime] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cia_Aer] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
 CONSTRAINT [PK_Proposta_Tar_Aer] PRIMARY KEY CLUSTERED 
(
	[PROCOD] ASC,
	[PRAID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Proposta_Rot_Aer] UNIQUE NONCLUSTERED 
(
	[PRAOrg] ASC,
	[PRADst] ASC,
	[PRAGat] ASC,
	[Cd_Cia_Aer] ASC,
	[TptID] ASC,
	[PRAFreq] ASC,
	[PROCOD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Proposta_Rot_Aer_Cia_Aerea] FOREIGN KEY([Cd_Cia_Aer])
REFERENCES [dbo].[Cia_Aerea] ([Cd_Cia_Aer])
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer] CHECK CONSTRAINT [FK_Proposta_Rot_Aer_Cia_Aerea]
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Proposta_Rot_Aer_Localidade] FOREIGN KEY([PRAOrg])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer] CHECK CONSTRAINT [FK_Proposta_Rot_Aer_Localidade]
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Proposta_Rot_Aer_Localidade1] FOREIGN KEY([PRADst])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer] CHECK CONSTRAINT [FK_Proposta_Rot_Aer_Localidade1]
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Proposta_Rot_Aer_Localidade2] FOREIGN KEY([PRAGat])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer] CHECK CONSTRAINT [FK_Proposta_Rot_Aer_Localidade2]
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Proposta_Rot_Aer_Tipo_Moeda] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer] CHECK CONSTRAINT [FK_Proposta_Rot_Aer_Tipo_Moeda]
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Proposta_Rot_Aer_Tipo_Tarifario] FOREIGN KEY([TptID])
REFERENCES [dbo].[Tipo_Tarifario] ([TptID])
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer] CHECK CONSTRAINT [FK_Proposta_Rot_Aer_Tipo_Tarifario]
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Proposta_Tar_Aer_Proposta] FOREIGN KEY([PROCOD])
REFERENCES [dbo].[Proposta] ([PROCOD])
GO
ALTER TABLE [dbo].[Proposta_Rot_Aer] CHECK CONSTRAINT [FK_Proposta_Tar_Aer_Proposta]
GO
