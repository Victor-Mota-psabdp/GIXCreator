SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Job_Imp_Mar](
	[Num_Proc_HIM] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Terminal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Armador] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[BL_Orig] [bit] NOT NULL,
	[Fat_Orig] [bit] NOT NULL,
	[Cd_Agente] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_HIM] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Inv_HIM] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Vendedor] [varchar](6) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_Job_Imp_Mar_01] ON [dbo].[Job_Imp_Mar]
(
	[Num_Proc_HIM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Job_Imp_Mar] ADD  DEFAULT (0) FOR [BL_Orig]
GO
ALTER TABLE [dbo].[Job_Imp_Mar] ADD  DEFAULT (0) FOR [Fat_Orig]
GO
ALTER TABLE [dbo].[Job_Imp_Mar]  WITH CHECK ADD  CONSTRAINT [FK_Job_Imp_Mar_Armador] FOREIGN KEY([Cd_Armador])
REFERENCES [dbo].[Armador] ([Cd_Armador])
GO
ALTER TABLE [dbo].[Job_Imp_Mar] CHECK CONSTRAINT [FK_Job_Imp_Mar_Armador]
GO
ALTER TABLE [dbo].[Job_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Job_Imp_Mar_Pessoa] FOREIGN KEY([Cd_Agente])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Job_Imp_Mar] CHECK CONSTRAINT [FK_Job_Imp_Mar_Pessoa]
GO
ALTER TABLE [dbo].[Job_Imp_Mar]  WITH CHECK ADD  CONSTRAINT [FK_Job_Imp_Mar_Usuario] FOREIGN KEY([cd_usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
ALTER TABLE [dbo].[Job_Imp_Mar] CHECK CONSTRAINT [FK_Job_Imp_Mar_Usuario]
GO
