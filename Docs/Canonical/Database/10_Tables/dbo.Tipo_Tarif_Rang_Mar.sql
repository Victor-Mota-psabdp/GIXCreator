SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Tarif_Rang_Mar](
	[TptID] [int] NOT NULL,
	[Cd_Tp_Cont] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[TtmFator] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[TtmValor] [float] NOT NULL,
 CONSTRAINT [PK_Tipo_Tarif_Rang_Mar] PRIMARY KEY CLUSTERED 
(
	[TptID] ASC,
	[Cd_Tp_Cont] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tipo_Tarif_Rang_Mar]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Tarif_Rang_Mar_Tipo_Cont_Tar] FOREIGN KEY([Cd_Tp_Cont])
REFERENCES [dbo].[Tipo_Cont_Tar] ([Cd_Tp_Cont])
GO
ALTER TABLE [dbo].[Tipo_Tarif_Rang_Mar] CHECK CONSTRAINT [FK_Tipo_Tarif_Rang_Mar_Tipo_Cont_Tar]
GO
ALTER TABLE [dbo].[Tipo_Tarif_Rang_Mar]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Tarif_Rang_Mar_Tipo_Tarifario] FOREIGN KEY([TptID])
REFERENCES [dbo].[Tipo_Tarifario] ([TptID])
GO
ALTER TABLE [dbo].[Tipo_Tarif_Rang_Mar] CHECK CONSTRAINT [FK_Tipo_Tarif_Rang_Mar_Tipo_Tarifario]
GO
