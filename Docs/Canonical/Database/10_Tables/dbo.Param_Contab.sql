SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Param_Contab](
	[CtaRecAer] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[CtaRecMar] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[CtaRecRec] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[CtaDesOpr] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[CtaDesAdm] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[CtaForn] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[CtaPrjOpr] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Ult_Contab] [varchar](7) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Param_Contab]  WITH CHECK ADD  CONSTRAINT [FK_Param_Contab_Cta_Ctb] FOREIGN KEY([CtaRecAer])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[Param_Contab] CHECK CONSTRAINT [FK_Param_Contab_Cta_Ctb]
GO
ALTER TABLE [dbo].[Param_Contab]  WITH CHECK ADD  CONSTRAINT [FK_Param_Contab_Cta_Ctb1] FOREIGN KEY([CtaRecMar])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[Param_Contab] CHECK CONSTRAINT [FK_Param_Contab_Cta_Ctb1]
GO
ALTER TABLE [dbo].[Param_Contab]  WITH CHECK ADD  CONSTRAINT [FK_Param_Contab_Cta_Ctb2] FOREIGN KEY([CtaRecRec])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[Param_Contab] CHECK CONSTRAINT [FK_Param_Contab_Cta_Ctb2]
GO
ALTER TABLE [dbo].[Param_Contab]  WITH CHECK ADD  CONSTRAINT [FK_Param_Contab_Cta_Ctb3] FOREIGN KEY([CtaDesOpr])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[Param_Contab] CHECK CONSTRAINT [FK_Param_Contab_Cta_Ctb3]
GO
ALTER TABLE [dbo].[Param_Contab]  WITH CHECK ADD  CONSTRAINT [FK_Param_Contab_Cta_Ctb4] FOREIGN KEY([CtaDesAdm])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[Param_Contab] CHECK CONSTRAINT [FK_Param_Contab_Cta_Ctb4]
GO
ALTER TABLE [dbo].[Param_Contab]  WITH CHECK ADD  CONSTRAINT [FK_Param_Contab_Cta_Ctb5] FOREIGN KEY([CtaDesAdm])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[Param_Contab] CHECK CONSTRAINT [FK_Param_Contab_Cta_Ctb5]
GO
ALTER TABLE [dbo].[Param_Contab]  WITH CHECK ADD  CONSTRAINT [FK_Param_Contab_Cta_Ctb6] FOREIGN KEY([CtaForn])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[Param_Contab] CHECK CONSTRAINT [FK_Param_Contab_Cta_Ctb6]
GO
ALTER TABLE [dbo].[Param_Contab]  WITH CHECK ADD  CONSTRAINT [FK_Param_Contab_Cta_Ctb7] FOREIGN KEY([CtaPrjOpr])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[Param_Contab] CHECK CONSTRAINT [FK_Param_Contab_Cta_Ctb7]
GO
