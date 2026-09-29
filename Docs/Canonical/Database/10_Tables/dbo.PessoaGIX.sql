SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PessoaGIX](
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Apelido] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Raz_Soc] [varchar](60) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_CPF_CNPJ] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_RG_IE] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Ativ] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Classe] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Grupo] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cta_Ctb] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Cad] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desat_Pes] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Obs_Pes] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Num_Insc_Munic] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Pes] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dupl_Cta_Master] [bit] NOT NULL,
	[Email] [varchar](75) COLLATE Latin1_General_CI_AI NULL,
	[PgtoRcto] [bit] NOT NULL,
	[GLOBAL_ENTITY_ID] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[GIX_HT_Customer] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__PessoaGIX__17036CC0] PRIMARY KEY CLUSTERED 
(
	[Cd_Pes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__PessoaGIX__0880433F] UNIQUE NONCLUSTERED 
(
	[Apelido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PessoaGIX] ADD  CONSTRAINT [DF_PessoaGIX_Cd_Tp_Pes]  DEFAULT ('J') FOR [Cd_Tp_Pes]
GO
ALTER TABLE [dbo].[PessoaGIX] ADD  CONSTRAINT [DF_PessoaGIX_Dupl_Cta_Master]  DEFAULT ((0)) FOR [Dupl_Cta_Master]
GO
ALTER TABLE [dbo].[PessoaGIX] ADD  CONSTRAINT [DF_PessoaGIX_PgtoRcto]  DEFAULT ((1)) FOR [PgtoRcto]
GO
ALTER TABLE [dbo].[PessoaGIX]  WITH NOCHECK ADD  CONSTRAINT [FK__PessoaGIX__Cd_Cta_C__2704CA5F] FOREIGN KEY([Cd_Cta_Ctb])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[PessoaGIX] CHECK CONSTRAINT [FK__PessoaGIX__Cd_Cta_C__2704CA5F]
GO
ALTER TABLE [dbo].[PessoaGIX]  WITH NOCHECK ADD  CONSTRAINT [FK__PessoaGIX__Cd_Tp_At__27F8EE98] FOREIGN KEY([Cd_Tp_Ativ])
REFERENCES [dbo].[Tipo_Atividade] ([Cd_Tp_Ativ])
GO
ALTER TABLE [dbo].[PessoaGIX] CHECK CONSTRAINT [FK__PessoaGIX__Cd_Tp_At__27F8EE98]
GO
ALTER TABLE [dbo].[PessoaGIX]  WITH NOCHECK ADD  CONSTRAINT [FK__PessoaGIX__Cd_Tp_Cl__28ED12D1] FOREIGN KEY([Cd_Tp_Classe])
REFERENCES [dbo].[Tipo_Classe] ([Cd_Tp_Classe])
GO
ALTER TABLE [dbo].[PessoaGIX] CHECK CONSTRAINT [FK__PessoaGIX__Cd_Tp_Cl__28ED12D1]
GO
ALTER TABLE [dbo].[PessoaGIX]  WITH NOCHECK ADD  CONSTRAINT [FK__PessoaGIX__Cd_Tp_Gr__29E1370A] FOREIGN KEY([Cd_Tp_Grupo])
REFERENCES [dbo].[Tipo_Grupo] ([Cd_Tp_Grupo])
GO
ALTER TABLE [dbo].[PessoaGIX] CHECK CONSTRAINT [FK__PessoaGIX__Cd_Tp_Gr__29E1370A]
GO
ALTER TABLE [dbo].[PessoaGIX]  WITH NOCHECK ADD  CONSTRAINT [FK__PessoaGIX__Cd_Usuar__2AD55B43] FOREIGN KEY([Cd_Usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
ALTER TABLE [dbo].[PessoaGIX] CHECK CONSTRAINT [FK__PessoaGIX__Cd_Usuar__2AD55B43]
GO
