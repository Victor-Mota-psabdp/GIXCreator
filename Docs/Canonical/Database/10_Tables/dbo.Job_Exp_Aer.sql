SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Job_Exp_Aer](
	[Num_Proc_HEA] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Agente] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_HEA] [char](25) COLLATE Latin1_General_CI_AI NULL,
	[Inv_HEA] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Embal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Vendedor] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Job_Exp_Aer] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HEA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Job_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Job_Exp_Aer_Pessoa] FOREIGN KEY([Cd_Agente])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Job_Exp_Aer] CHECK CONSTRAINT [FK_Job_Exp_Aer_Pessoa]
GO
ALTER TABLE [dbo].[Job_Exp_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Job_Exp_Aer_Tipo_Embalagem] FOREIGN KEY([Cd_Tp_Embal])
REFERENCES [dbo].[Tipo_Embalagem] ([Cd_Tp_Embal])
GO
ALTER TABLE [dbo].[Job_Exp_Aer] CHECK CONSTRAINT [FK_Job_Exp_Aer_Tipo_Embalagem]
GO
ALTER TABLE [dbo].[Job_Exp_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Job_Exp_Aer_Usuario] FOREIGN KEY([Cd_Usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
ALTER TABLE [dbo].[Job_Exp_Aer] CHECK CONSTRAINT [FK_Job_Exp_Aer_Usuario]
GO
