SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Demurrage_Neg_Imp_Mar](
	[Num_Proc_HIM] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Cont] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Free_Time_IM] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tx_Diaria_IM] [decimal](7, 6) NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[Num_Proc_HIM] ASC,
	[Cd_Tp_Cont] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Demurrage_Neg_Imp_Mar]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Cont])
REFERENCES [dbo].[Tipo_Container] ([Cd_Tp_Cont])
GO
ALTER TABLE [dbo].[Demurrage_Neg_Imp_Mar]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Demurrage_Neg_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Demurrage__Num_P__3D7E1B63] FOREIGN KEY([Num_Proc_HIM])
REFERENCES [dbo].[House_Imp_Mar] ([Num_Proc_HIM])
GO
ALTER TABLE [dbo].[Demurrage_Neg_Imp_Mar] CHECK CONSTRAINT [FK__Demurrage__Num_P__3D7E1B63]
GO
