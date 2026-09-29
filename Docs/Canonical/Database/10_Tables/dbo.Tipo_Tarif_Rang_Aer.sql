SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Tarif_Rang_Aer](
	[TptID] [int] NOT NULL,
	[TtaFator] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[TtaMin] [float] NULL,
	[Tta0] [float] NULL,
	[Tta45] [float] NULL,
	[Tta100] [float] NULL,
	[Tta300] [float] NULL,
	[Tta500] [float] NULL,
	[Tta1000] [float] NULL,
	[Tta2000] [float] NULL,
 CONSTRAINT [PK_Tipo_Tarif_Rang_Aer] PRIMARY KEY CLUSTERED 
(
	[TptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tipo_Tarif_Rang_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Tarif_Rang_Aer_Tipo_Tarifario] FOREIGN KEY([TptID])
REFERENCES [dbo].[Tipo_Tarifario] ([TptID])
GO
ALTER TABLE [dbo].[Tipo_Tarif_Rang_Aer] CHECK CONSTRAINT [FK_Tipo_Tarif_Rang_Aer_Tipo_Tarifario]
GO
