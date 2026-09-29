SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Proposta_Rot_Mar](
	[PROCOD] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRMID] [int] NOT NULL,
	[PRMOrg] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRMDst] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRMGat] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Armador] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TptID] [int] NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRMTTime] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[PRMFreq] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
 CONSTRAINT [PK_Proposta_Rot_Mar] PRIMARY KEY CLUSTERED 
(
	[PROCOD] ASC,
	[PRMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Proposta_Rot_Mar] UNIQUE NONCLUSTERED 
(
	[PRMOrg] ASC,
	[PRMDst] ASC,
	[PRMGat] ASC,
	[Cd_Armador] ASC,
	[TptID] ASC,
	[PRMFreq] ASC,
	[PROCOD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Proposta_Rot_Mar]  WITH CHECK ADD  CONSTRAINT [FK_Proposta_Rot_Mar_Armador] FOREIGN KEY([Cd_Armador])
REFERENCES [dbo].[Armador] ([Cd_Armador])
GO
ALTER TABLE [dbo].[Proposta_Rot_Mar] CHECK CONSTRAINT [FK_Proposta_Rot_Mar_Armador]
GO
ALTER TABLE [dbo].[Proposta_Rot_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Proposta_Rot_Mar_Localidade] FOREIGN KEY([PRMOrg])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Proposta_Rot_Mar] CHECK CONSTRAINT [FK_Proposta_Rot_Mar_Localidade]
GO
ALTER TABLE [dbo].[Proposta_Rot_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Proposta_Rot_Mar_Localidade1] FOREIGN KEY([PRMDst])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Proposta_Rot_Mar] CHECK CONSTRAINT [FK_Proposta_Rot_Mar_Localidade1]
GO
ALTER TABLE [dbo].[Proposta_Rot_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Proposta_Rot_Mar_Localidade2] FOREIGN KEY([PRMGat])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Proposta_Rot_Mar] CHECK CONSTRAINT [FK_Proposta_Rot_Mar_Localidade2]
GO
ALTER TABLE [dbo].[Proposta_Rot_Mar]  WITH CHECK ADD  CONSTRAINT [FK_Proposta_Rot_Mar_Tipo_Moeda] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Proposta_Rot_Mar] CHECK CONSTRAINT [FK_Proposta_Rot_Mar_Tipo_Moeda]
GO
ALTER TABLE [dbo].[Proposta_Rot_Mar]  WITH CHECK ADD  CONSTRAINT [FK_Proposta_Rot_Mar_Tipo_Tarifario] FOREIGN KEY([TptID])
REFERENCES [dbo].[Tipo_Tarifario] ([TptID])
GO
ALTER TABLE [dbo].[Proposta_Rot_Mar] CHECK CONSTRAINT [FK_Proposta_Rot_Mar_Tipo_Tarifario]
GO
