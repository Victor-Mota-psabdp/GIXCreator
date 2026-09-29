SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Job_Exp_Mar](
	[Num_Proc_HEM] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Nr_Reserva] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Dead_Line] [datetime] NULL,
	[Cd_Tp_Com_Cli] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes_Dcto] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Com_Dcto] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes_Crg] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Com_Crg] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Dt_ETA] [datetime] NULL,
	[Obs_JEM] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Agente] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_HEM] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Inv_HEM] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Vendedor] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Retirada_Vazios] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_JOB_HEM] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HEM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Job_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Job_Exp_Mar_Pessoa] FOREIGN KEY([Cd_Agente])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Job_Exp_Mar] CHECK CONSTRAINT [FK_Job_Exp_Mar_Pessoa]
GO
ALTER TABLE [dbo].[Job_Exp_Mar]  WITH CHECK ADD  CONSTRAINT [FK_JOB_HEM_Usuario] FOREIGN KEY([Cd_Usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
ALTER TABLE [dbo].[Job_Exp_Mar] CHECK CONSTRAINT [FK_JOB_HEM_Usuario]
GO
