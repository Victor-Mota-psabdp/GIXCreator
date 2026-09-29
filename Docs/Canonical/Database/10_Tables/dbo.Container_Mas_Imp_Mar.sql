SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Container_Mas_Imp_Mar](
	[Num_Proc_MIM] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_Cont_IM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Cont] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Cont_IM] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lacre_IM] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Vcto_Devol_IM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Devol_IM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Lacre_02_IM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Lacre_03_IM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Lacre_04_IM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Bruto_IM] [float] NULL,
	[VolumeM3] [float] NULL,
	[ID_ISO] [int] NULL,
	[Tara_IM] [float] NULL,
	[DataDevCli_IM] [datetime] NULL,
	[inspecao] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
 CONSTRAINT [PK__Container_Mas_Im__40F9A68C] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_MIM] ASC,
	[Item_Cont_IM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Container_Mas_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Container__Cd_Tp__58671BC9] FOREIGN KEY([Cd_Tp_Cont])
REFERENCES [dbo].[Tipo_Container] ([Cd_Tp_Cont])
GO
ALTER TABLE [dbo].[Container_Mas_Imp_Mar] CHECK CONSTRAINT [FK__Container__Cd_Tp__58671BC9]
GO
ALTER TABLE [dbo].[Container_Mas_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Container__Num_P__52EE3995] FOREIGN KEY([Num_Proc_MIM])
REFERENCES [dbo].[Master_Imp_Mar] ([Num_Proc_MIM])
GO
ALTER TABLE [dbo].[Container_Mas_Imp_Mar] CHECK CONSTRAINT [FK__Container__Num_P__52EE3995]
GO
ALTER TABLE [dbo].[Container_Mas_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Container_Mas_Imp_Mar_ISO] FOREIGN KEY([ID_ISO])
REFERENCES [dbo].[ISO] ([ID_ISO])
GO
ALTER TABLE [dbo].[Container_Mas_Imp_Mar] CHECK CONSTRAINT [FK_Container_Mas_Imp_Mar_ISO]
GO
