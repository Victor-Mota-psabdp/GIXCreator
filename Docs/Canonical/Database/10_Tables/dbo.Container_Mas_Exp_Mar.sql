SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Container_Mas_Exp_Mar](
	[Num_Proc_MEM] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_Cont_EM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Cont] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Cont_EM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Num_Lacre_EM] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Lacre_02_EM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Lacre_03_EM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Lacre_04_EM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Bruto_EM] [float] NULL,
	[VolumeM3] [float] NULL,
	[ID_ISO] [int] NULL,
	[Tara_EM] [float] NULL,
	[Temperature] [float] NULL,
	[Vent_Status] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Battery_Time] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Volt] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Graus] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Vcto_Devol_EM] [datetime] NULL,
	[Dt_Est_Devol_EM] [datetime] NULL,
	[Peso_Liquido_EM] [float] NULL,
 CONSTRAINT [PK__Container_Mas_Ex__40058253] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_MEM] ASC,
	[Item_Cont_EM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Container_Mas_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Container__Num_P__5772F790] FOREIGN KEY([Num_Proc_MEM])
REFERENCES [dbo].[Master_Exp_Mar] ([Num_Proc_MEM])
GO
ALTER TABLE [dbo].[Container_Mas_Exp_Mar] CHECK CONSTRAINT [FK__Container__Num_P__5772F790]
GO
