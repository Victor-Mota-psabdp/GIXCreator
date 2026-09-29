SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Job_Imp_Aer](
	[Num_Proc_HIA] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cia_Aer] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Agente] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_HIA] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Inv_HIA] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Embal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Vendedor] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Job_Imp_Aer] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Job_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Job_Imp_Aer_Pessoa] FOREIGN KEY([Cd_Agente])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Job_Imp_Aer] CHECK CONSTRAINT [FK_Job_Imp_Aer_Pessoa]
GO
ALTER TABLE [dbo].[Job_Imp_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Job_Imp_Aer_Tipo_Embalagem] FOREIGN KEY([Cd_Tp_Embal])
REFERENCES [dbo].[Tipo_Embalagem] ([Cd_Tp_Embal])
GO
ALTER TABLE [dbo].[Job_Imp_Aer] CHECK CONSTRAINT [FK_Job_Imp_Aer_Tipo_Embalagem]
GO
ALTER TABLE [dbo].[Job_Imp_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Job_Imp_Aer_Usuario] FOREIGN KEY([cd_usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
ALTER TABLE [dbo].[Job_Imp_Aer] CHECK CONSTRAINT [FK_Job_Imp_Aer_Usuario]
GO
