SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tarifa_Exp_Mar](
	[Cd_Org_TEM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst_TEM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Via_TEM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Armador] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Crg_Esp_TEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Trf_TEM] [varchar](7) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Ftr_FCL_TEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Fator_FCL_TEM] [decimal](5, 2) NULL,
	[Trf_Cp_1_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_1_TEM] [decimal](8, 2) NULL,
	[Trf_Cp_2_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_2_TEM] [decimal](8, 2) NULL,
	[Trf_Cp_3_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_3_TEM] [decimal](8, 2) NULL,
	[Trf_Cp_4_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_4_TEM] [decimal](8, 2) NULL,
	[Trf_Cp_5_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_5_TEM] [decimal](8, 2) NULL,
	[Trf_Cp_6_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_6_TEM] [decimal](8, 2) NULL,
	[Trf_Cp_7_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_7_TEM] [decimal](8, 2) NULL,
	[Trf_Cp_8_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_8_TEM] [decimal](8, 2) NULL,
	[Trf_Cp_9_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_9_TEM] [decimal](8, 2) NULL,
	[Trf_Cp_10_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_10_TEM] [decimal](8, 2) NULL,
	[Tp_Ftr_LCL_TEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Fator_LCL_TEM] [decimal](5, 2) NULL,
	[Trf_Cp_11_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_11_TEM] [decimal](8, 2) NULL,
	[Trf_Cp_12_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_12_TEM] [decimal](8, 2) NULL,
	[Trf_Cp_13_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_13_TEM] [decimal](8, 2) NULL,
	[Trf_Cp_14_TEM] [decimal](8, 2) NULL,
	[Trf_Vd_14_TEM] [decimal](8, 2) NULL,
	[Trst_Time_TEM] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Freq_TEM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Val_TEM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Obs_TEM] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Cd_Org_TEM] ASC,
	[Cd_Dst_TEM] ASC,
	[Cd_Via_TEM] ASC,
	[Cd_Armador] ASC,
	[Crg_Esp_TEM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tarifa_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ex__Cd_Ar__308E3499] FOREIGN KEY([Cd_Armador])
REFERENCES [dbo].[Armador] ([Cd_Armador])
GO
ALTER TABLE [dbo].[Tarifa_Exp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ex__Cd_Ar__308E3499]
GO
ALTER TABLE [dbo].[Tarifa_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ex__Cd_Ds__318258D2] FOREIGN KEY([Cd_Dst_TEM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Exp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ex__Cd_Ds__318258D2]
GO
ALTER TABLE [dbo].[Tarifa_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ex__Cd_Or__32767D0B] FOREIGN KEY([Cd_Org_TEM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Exp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ex__Cd_Or__32767D0B]
GO
ALTER TABLE [dbo].[Tarifa_Exp_Mar]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Tarifa_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ex__Cd_Vi__345EC57D] FOREIGN KEY([Cd_Via_TEM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Exp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ex__Cd_Vi__345EC57D]
GO
