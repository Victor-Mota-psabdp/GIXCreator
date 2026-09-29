SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Taxa_Neg_Imp_Aer](
	[Num_Prop_IA] [varchar](11) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Peso_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Grupo] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Tx_TNIA] [decimal](10, 2) NOT NULL,
	[Desp_Org_TNIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_Prev_TNIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Prop_IA] ASC,
	[Cd_Tp_Tx] ASC,
	[Cd_Peso_Tx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Taxa_Neg_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Peso_Tx])
REFERENCES [dbo].[Peso_Taxa] ([Cd_Peso_Tx])
GO
ALTER TABLE [dbo].[Taxa_Neg_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Taxa_Neg_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Grupo])
REFERENCES [dbo].[Tipo_Grupo] ([Cd_Tp_Grupo])
GO
ALTER TABLE [dbo].[Taxa_Neg_Imp_Aer]  WITH CHECK ADD  CONSTRAINT [FK__Taxa_Neg___Cd_Tp__4830B400] FOREIGN KEY([Cd_Tp_Tx])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Taxa_Neg_Imp_Aer] CHECK CONSTRAINT [FK__Taxa_Neg___Cd_Tp__4830B400]
GO
ALTER TABLE [dbo].[Taxa_Neg_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Taxa_Neg___Num_P__4924D839] FOREIGN KEY([Num_Prop_IA])
REFERENCES [dbo].[Proposta_Imp_Aer] ([Num_Prop_IA])
GO
ALTER TABLE [dbo].[Taxa_Neg_Imp_Aer] CHECK CONSTRAINT [FK__Taxa_Neg___Num_P__4924D839]
GO
