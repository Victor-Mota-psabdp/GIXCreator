SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Campo_Ordem](
	[Id_Campo] [int] NOT NULL,
	[cd_pes_grupo] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tipo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Descr_Campo] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Tab_Relacionada] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cod_Busca_PK] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Campo_Exibicao] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Ativo] [int] NULL,
 CONSTRAINT [PK__Tipo_Campo_Ordem__04BDCCAF] PRIMARY KEY CLUSTERED 
(
	[Id_Campo] ASC,
	[cd_pes_grupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tipo_Campo_Ordem]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Campo_Ordem_Tipo_Campo_Ordem] FOREIGN KEY([Id_Campo], [cd_pes_grupo])
REFERENCES [dbo].[Tipo_Campo_Ordem] ([Id_Campo], [cd_pes_grupo])
GO
ALTER TABLE [dbo].[Tipo_Campo_Ordem] CHECK CONSTRAINT [FK_Tipo_Campo_Ordem_Tipo_Campo_Ordem]
GO
