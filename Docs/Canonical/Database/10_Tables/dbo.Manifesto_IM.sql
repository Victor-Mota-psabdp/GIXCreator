SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Manifesto_IM](
	[Bl_Master] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Id_Viagem] [int] NOT NULL,
	[Tp_Manifesto] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Master_Cop] [int] NOT NULL,
	[SubMaster_Cop] [int] NOT NULL,
	[HBL_Cop] [int] NOT NULL,
	[SubMaster_NN_Cop] [int] NOT NULL,
	[Dec_Agente] [int] NOT NULL,
	[DARF] [int] NOT NULL,
	[Outros] [int] NOT NULL,
	[Prazo] [bit] NOT NULL,
	[Multa_Vol] [varchar](100) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Embarque] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Represent] [int] NOT NULL,
	[Dt_Manifesto] [datetime] NULL,
 CONSTRAINT [PK_Manifesto_IM] PRIMARY KEY CLUSTERED 
(
	[Bl_Master] ASC,
	[Id_Viagem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Manifesto_IM] ADD  CONSTRAINT [DF_Manifesto_IM_Prazo]  DEFAULT (1) FOR [Prazo]
GO
ALTER TABLE [dbo].[Manifesto_IM] ADD  DEFAULT (1) FOR [Cd_Represent]
GO
ALTER TABLE [dbo].[Manifesto_IM]  WITH NOCHECK ADD  CONSTRAINT [FK_Manifesto_IM_Localidade] FOREIGN KEY([Cd_Embarque])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Manifesto_IM] CHECK CONSTRAINT [FK_Manifesto_IM_Localidade]
GO
ALTER TABLE [dbo].[Manifesto_IM]  WITH CHECK ADD  CONSTRAINT [FK_Manifesto_IM_Represent_Manif] FOREIGN KEY([Cd_Represent])
REFERENCES [dbo].[Represent_Manif] ([Cd_Represent])
GO
ALTER TABLE [dbo].[Manifesto_IM] CHECK CONSTRAINT [FK_Manifesto_IM_Represent_Manif]
GO
