SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tarifa_Neg_Imp_Mar](
	[Num_Prop_IM] [varchar](11) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Org_TNIM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst_TNIM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Via_TNIM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Armador] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Crg_Esp_TNIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Trf_TNIM] [varchar](7) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Ftr_FCL_TNIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Fator_FCL_TNIM] [decimal](5, 2) NULL,
	[Trf_Cp_1_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_1_TNIM] [decimal](8, 2) NULL,
	[Trf_Cp_2_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_2_TNIM] [decimal](8, 2) NULL,
	[Trf_Cp_3_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_3_TNIM] [decimal](8, 2) NULL,
	[Trf_Cp_4_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_4_TNIM] [decimal](8, 2) NULL,
	[Trf_Cp_5_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_5_TNIM] [decimal](8, 2) NULL,
	[Trf_Cp_6_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_6_TNIM] [decimal](8, 2) NULL,
	[Trf_Cp_7_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_7_TNIM] [decimal](8, 2) NULL,
	[Trf_Cp_8_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_8_TNIM] [decimal](8, 2) NULL,
	[Trf_Cp_9_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_9_TNIM] [decimal](8, 2) NULL,
	[Trf_Cp_10_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_10_TNIM] [decimal](8, 2) NULL,
	[Tp_Ftr_LCL_TNIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Fator_LCL_TNIM] [decimal](5, 2) NULL,
	[Trf_Cp_11_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_11_TNIM] [decimal](8, 2) NULL,
	[Trf_Cp_12_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_12_TNIM] [decimal](8, 2) NULL,
	[Trf_Cp_13_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_13_TNIM] [decimal](8, 2) NULL,
	[Trf_Cp_14_TNIM] [decimal](8, 2) NULL,
	[Trf_Vd_14_TNIM] [decimal](8, 2) NULL,
	[Trst_Time_TNIM] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Freq_TNIM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Zip_Code_TNIM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Obs_TNIM] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Prop_IM] ASC,
	[Cd_Org_TNIM] ASC,
	[Cd_Dst_TNIM] ASC,
	[Cd_Via_TNIM] ASC,
	[Cd_Armador] ASC,
	[Crg_Esp_TNIM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Ar__361203C5] FOREIGN KEY([Cd_Armador])
REFERENCES [dbo].[Armador] ([Cd_Armador])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Ar__361203C5]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Ds__370627FE] FOREIGN KEY([Cd_Dst_TNIM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Ds__370627FE]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Or__37FA4C37] FOREIGN KEY([Cd_Org_TNIM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Or__37FA4C37]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Mar]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Vi__39E294A9] FOREIGN KEY([Cd_Via_TNIM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Vi__39E294A9]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Num_P__3AD6B8E2] FOREIGN KEY([Num_Prop_IM])
REFERENCES [dbo].[Proposta_Imp_Mar] ([Num_Prop_IM])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ne__Num_P__3AD6B8E2]
GO
