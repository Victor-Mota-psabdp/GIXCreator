SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Campo_Automatico](
	[Id_Campo] [int] NOT NULL,
	[Cd_Pes_Grupo] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tipo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Descr_Campo] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Tab_Relacionada] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[Cod_Busca] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Campo_Exibicao] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[View] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Tipo_Campo_Automatico] PRIMARY KEY CLUSTERED 
(
	[Id_Campo] ASC,
	[Cd_Pes_Grupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tipo_Campo_Automatico]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Campo_Automatico_Tipo_Campo_Automatico] FOREIGN KEY([Id_Campo], [Cd_Pes_Grupo])
REFERENCES [dbo].[Tipo_Campo_Automatico] ([Id_Campo], [Cd_Pes_Grupo])
GO
ALTER TABLE [dbo].[Tipo_Campo_Automatico] CHECK CONSTRAINT [FK_Tipo_Campo_Automatico_Tipo_Campo_Automatico]
GO
