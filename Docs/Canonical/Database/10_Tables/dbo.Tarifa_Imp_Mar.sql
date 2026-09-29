SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tarifa_Imp_Mar](
	[Cd_Org_TIM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst_TIM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Via_TIM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Armador] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Crg_Esp_TIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Trf_TIM] [varchar](7) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Ftr_FCL_TIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Fator_FCL_TIM] [decimal](5, 2) NULL,
	[Trf_Cp_1_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_1_TIM] [decimal](8, 2) NULL,
	[Trf_Cp_2_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_2_TIM] [decimal](8, 2) NULL,
	[Trf_Cp_3_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_3_TIM] [decimal](8, 2) NULL,
	[Trf_Cp_4_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_4_TIM] [decimal](8, 2) NULL,
	[Trf_Cp_5_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_5_TIM] [decimal](8, 2) NULL,
	[Trf_Cp_6_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_6_TIM] [decimal](8, 2) NULL,
	[Trf_Cp_7_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_7_TIM] [decimal](8, 2) NULL,
	[Trf_Cp_8_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_8_TIM] [decimal](8, 2) NULL,
	[Trf_Cp_9_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_9_TIM] [decimal](8, 2) NULL,
	[Trf_Cp_10_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_10_TIM] [decimal](8, 2) NULL,
	[Tp_Ftr_LCL_TIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Fator_LCL_TIM] [decimal](5, 2) NULL,
	[Trf_Cp_11_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_11_TIM] [decimal](8, 2) NULL,
	[Trf_Cp_12_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_12_TIM] [decimal](8, 2) NULL,
	[Trf_Cp_13_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_13_TIM] [decimal](8, 2) NULL,
	[Trf_Cp_14_TIM] [decimal](8, 2) NULL,
	[Trf_Vd_14_TIM] [decimal](8, 2) NULL,
	[Trst_Time_TIM] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Freq_TIM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Val_TIM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Obs_TIM] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Cd_Org_TIM] ASC,
	[Cd_Dst_TIM] ASC,
	[Cd_Via_TIM] ASC,
	[Cd_Armador] ASC,
	[Crg_Esp_TIM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tarifa_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Im__Cd_Ar__3A179ED3] FOREIGN KEY([Cd_Armador])
REFERENCES [dbo].[Armador] ([Cd_Armador])
GO
ALTER TABLE [dbo].[Tarifa_Imp_Mar] CHECK CONSTRAINT [FK__Tarifa_Im__Cd_Ar__3A179ED3]
GO
ALTER TABLE [dbo].[Tarifa_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Im__Cd_Ds__3B0BC30C] FOREIGN KEY([Cd_Dst_TIM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Imp_Mar] CHECK CONSTRAINT [FK__Tarifa_Im__Cd_Ds__3B0BC30C]
GO
ALTER TABLE [dbo].[Tarifa_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Im__Cd_Or__3BFFE745] FOREIGN KEY([Cd_Org_TIM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Imp_Mar] CHECK CONSTRAINT [FK__Tarifa_Im__Cd_Or__3BFFE745]
GO
ALTER TABLE [dbo].[Tarifa_Imp_Mar]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Tarifa_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Im__Cd_Vi__3DE82FB7] FOREIGN KEY([Cd_Via_TIM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Imp_Mar] CHECK CONSTRAINT [FK__Tarifa_Im__Cd_Vi__3DE82FB7]
GO
