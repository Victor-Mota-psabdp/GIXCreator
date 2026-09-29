SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Demurrage](
	[Cd_Armador] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Cont] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Free_Time] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tx_Diaria] [decimal](8, 6) NULL,
PRIMARY KEY NONCLUSTERED 
(
	[Cd_Armador] ASC,
	[Cd_Tp_Cont] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Demurrage]  WITH NOCHECK ADD  CONSTRAINT [FK__Demurrage__Cd_Ar__13F1F5EB] FOREIGN KEY([Cd_Armador])
REFERENCES [dbo].[Armador] ([Cd_Armador])
GO
ALTER TABLE [dbo].[Demurrage] CHECK CONSTRAINT [FK__Demurrage__Cd_Ar__13F1F5EB]
GO
ALTER TABLE [dbo].[Demurrage]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Cont])
REFERENCES [dbo].[Tipo_Container] ([Cd_Tp_Cont])
GO
ALTER TABLE [dbo].[Demurrage]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
