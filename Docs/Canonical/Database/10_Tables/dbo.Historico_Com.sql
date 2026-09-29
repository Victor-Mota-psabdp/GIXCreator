SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Historico_Com](
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Visita] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Repr_Cli] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Objetivo] [varchar](100) COLLATE Latin1_General_CI_AI NOT NULL,
	[Acoes] [varchar](100) COLLATE Latin1_General_CI_AI NOT NULL,
	[Descr_Visita] [varchar](2000) COLLATE Latin1_General_CI_AI NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cd_Pes] ASC,
	[Dt_Visita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Historico_Com]  WITH NOCHECK ADD  CONSTRAINT [FK__Historico__Cd_Pe__52E34C9D] FOREIGN KEY([Cd_Pes])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Historico_Com] CHECK CONSTRAINT [FK__Historico__Cd_Pe__52E34C9D]
GO
ALTER TABLE [dbo].[Historico_Com]  WITH CHECK ADD FOREIGN KEY([Cd_Usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
