SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Viagem_LLP](
	[ID_Viagem] [int] NOT NULL,
	[ID_Navio] [int] NOT NULL,
	[Modal] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[NR_Viagem] [varchar](8) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[ETD] [datetime] NULL,
	[ATD] [datetime] NULL,
	[ETA] [datetime] NULL,
	[ATA] [datetime] NULL,
	[Ativo] [bit] NOT NULL,
	[id_op] [int] NULL,
	[dt_ins] [datetime] NOT NULL,
	[cd_usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[manifesto] [varchar](11) COLLATE Latin1_General_CI_AI NULL,
	[Notes] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Ano_Viagem] [int] NULL,
	[Id_Terminal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Viagem_LLP_1] PRIMARY KEY CLUSTERED 
(
	[ID_Viagem] ASC,
	[ID_Navio] ASC,
	[Cd_Dst] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Viagem_LLP]  WITH CHECK ADD  CONSTRAINT [FK_Viagem_LLP_Localidade] FOREIGN KEY([Cd_Dst])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Viagem_LLP] CHECK CONSTRAINT [FK_Viagem_LLP_Localidade]
GO
ALTER TABLE [dbo].[Viagem_LLP]  WITH CHECK ADD  CONSTRAINT [FK_Viagem_LLP_Navio_LLP] FOREIGN KEY([ID_Navio])
REFERENCES [dbo].[Navio_LLP] ([Id_Navio])
GO
ALTER TABLE [dbo].[Viagem_LLP] CHECK CONSTRAINT [FK_Viagem_LLP_Navio_LLP]
GO
