SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Proposta_Imp_Aer](
	[Num_Prop_IA] [varchar](11) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_PIA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Import_PIA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ctt_Cli_PIA] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Prod] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Fonte] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Msg_PIA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Fchto_PIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cancel_PIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Obs_PIA] [varchar](4000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__Proposta_Imp_Aer__2739D489] PRIMARY KEY CLUSTERED 
(
	[Num_Prop_IA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Proposta_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Im__69C6B1F5] FOREIGN KEY([Cd_Import_PIA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Proposta_Imp_Aer] CHECK CONSTRAINT [FK__Proposta___Cd_Im__69C6B1F5]
GO
ALTER TABLE [dbo].[Proposta_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Tp__6ABAD62E] FOREIGN KEY([Cd_Tp_Prod])
REFERENCES [dbo].[Tipo_Produto] ([Cd_Tp_Prod])
GO
ALTER TABLE [dbo].[Proposta_Imp_Aer] CHECK CONSTRAINT [FK__Proposta___Cd_Tp__6ABAD62E]
GO
ALTER TABLE [dbo].[Proposta_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Tp__6BAEFA67] FOREIGN KEY([Cd_Tp_Fonte])
REFERENCES [dbo].[Tipo_Fonte] ([Cd_Tp_Fonte])
GO
ALTER TABLE [dbo].[Proposta_Imp_Aer] CHECK CONSTRAINT [FK__Proposta___Cd_Tp__6BAEFA67]
GO
ALTER TABLE [dbo].[Proposta_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Us__6CA31EA0] FOREIGN KEY([Cd_Usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
ALTER TABLE [dbo].[Proposta_Imp_Aer] CHECK CONSTRAINT [FK__Proposta___Cd_Us__6CA31EA0]
GO
