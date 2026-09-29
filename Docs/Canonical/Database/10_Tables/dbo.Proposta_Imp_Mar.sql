SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Proposta_Imp_Mar](
	[Num_Prop_IM] [varchar](11) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_PIM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Import_PIM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ctt_Cli_PIM] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Prod] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Fonte] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Msg_PIM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Fchto_PIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cancel_PIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Obs_PIM] [varchar](4000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__Proposta_Imp_Mar__282DF8C2] PRIMARY KEY CLUSTERED 
(
	[Num_Prop_IM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Proposta_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Im__6D9742D9] FOREIGN KEY([Cd_Import_PIM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Proposta_Imp_Mar] CHECK CONSTRAINT [FK__Proposta___Cd_Im__6D9742D9]
GO
ALTER TABLE [dbo].[Proposta_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Tp__6E8B6712] FOREIGN KEY([Cd_Tp_Prod])
REFERENCES [dbo].[Tipo_Produto] ([Cd_Tp_Prod])
GO
ALTER TABLE [dbo].[Proposta_Imp_Mar] CHECK CONSTRAINT [FK__Proposta___Cd_Tp__6E8B6712]
GO
ALTER TABLE [dbo].[Proposta_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Tp__6F7F8B4B] FOREIGN KEY([Cd_Tp_Fonte])
REFERENCES [dbo].[Tipo_Fonte] ([Cd_Tp_Fonte])
GO
ALTER TABLE [dbo].[Proposta_Imp_Mar] CHECK CONSTRAINT [FK__Proposta___Cd_Tp__6F7F8B4B]
GO
ALTER TABLE [dbo].[Proposta_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Us__7073AF84] FOREIGN KEY([Cd_Usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
ALTER TABLE [dbo].[Proposta_Imp_Mar] CHECK CONSTRAINT [FK__Proposta___Cd_Us__7073AF84]
GO
