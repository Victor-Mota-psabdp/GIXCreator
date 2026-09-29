SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Proposta_Exp_Mar](
	[Num_Prop_EM] [varchar](11) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_PEM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Export_PEM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ctt_Cli_PEM] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Prod] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Fonte] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Msg_PEM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Fchto_PEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cancel_PEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Obs_PEM] [varchar](4000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__Proposta_Exp_Mar__2645B050] PRIMARY KEY CLUSTERED 
(
	[Num_Prop_EM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Proposta_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Ex__65F62111] FOREIGN KEY([Cd_Export_PEM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Proposta_Exp_Mar] CHECK CONSTRAINT [FK__Proposta___Cd_Ex__65F62111]
GO
ALTER TABLE [dbo].[Proposta_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Tp__66EA454A] FOREIGN KEY([Cd_Tp_Prod])
REFERENCES [dbo].[Tipo_Produto] ([Cd_Tp_Prod])
GO
ALTER TABLE [dbo].[Proposta_Exp_Mar] CHECK CONSTRAINT [FK__Proposta___Cd_Tp__66EA454A]
GO
ALTER TABLE [dbo].[Proposta_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Tp__67DE6983] FOREIGN KEY([Cd_Tp_Fonte])
REFERENCES [dbo].[Tipo_Fonte] ([Cd_Tp_Fonte])
GO
ALTER TABLE [dbo].[Proposta_Exp_Mar] CHECK CONSTRAINT [FK__Proposta___Cd_Tp__67DE6983]
GO
ALTER TABLE [dbo].[Proposta_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Proposta___Cd_Us__68D28DBC] FOREIGN KEY([Cd_Usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
ALTER TABLE [dbo].[Proposta_Exp_Mar] CHECK CONSTRAINT [FK__Proposta___Cd_Us__68D28DBC]
GO
