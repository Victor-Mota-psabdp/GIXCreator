SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tarifa_Neg_Exp_Mar](
	[Num_Prop_EM] [varchar](11) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Org_TNEM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst_TNEM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Via_TNEM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Armador] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Crg_Esp_TNEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Trf_TNEM] [varchar](7) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Ftr_FCL_TNEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Fator_FCL_TNEM] [decimal](5, 2) NULL,
	[Trf_Cp_1_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_1_TNEM] [decimal](8, 2) NULL,
	[Trf_Cp_2_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_2_TNEM] [decimal](8, 2) NULL,
	[Trf_Cp_3_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_3_TNEM] [decimal](8, 2) NULL,
	[Trf_Cp_4_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_4_TNEM] [decimal](8, 2) NULL,
	[Trf_Cp_5_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_5_TNEM] [decimal](8, 2) NULL,
	[Trf_Cp_6_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_6_TNEM] [decimal](8, 2) NULL,
	[Trf_Cp_7_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_7_TNEM] [decimal](8, 2) NULL,
	[Trf_Cp_8_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_8_TNEM] [decimal](8, 2) NULL,
	[Trf_Cp_9_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_9_TNEM] [decimal](8, 2) NULL,
	[Trf_Cp_10_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_10_TNEM] [decimal](8, 2) NULL,
	[Tp_Ftr_LCL_TNEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Fator_LCL_TNEM] [decimal](5, 2) NULL,
	[Trf_Cp_11_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_11_TNEM] [decimal](8, 2) NULL,
	[Trf_Cp_12_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_12_TNEM] [decimal](8, 2) NULL,
	[Trf_Cp_13_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_13_TNEM] [decimal](8, 2) NULL,
	[Trf_Cp_14_TNEM] [decimal](8, 2) NULL,
	[Trf_Vd_14_TNEM] [decimal](8, 2) NULL,
	[Trst_Time_TNEM] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Freq_TNEM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Zip_Code_TNEM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Obs_TNEM] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Prop_EM] ASC,
	[Cd_Org_TNEM] ASC,
	[Cd_Dst_TNEM] ASC,
	[Cd_Via_TNEM] ASC,
	[Cd_Armador] ASC,
	[Crg_Esp_TNEM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Ar__2AA05119] FOREIGN KEY([Cd_Armador])
REFERENCES [dbo].[Armador] ([Cd_Armador])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Ar__2AA05119]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Ds__2B947552] FOREIGN KEY([Cd_Dst_TNEM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Ds__2B947552]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Or__2C88998B] FOREIGN KEY([Cd_Org_TNEM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Or__2C88998B]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Mar]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Vi__2E70E1FD] FOREIGN KEY([Cd_Via_TNEM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Vi__2E70E1FD]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Num_P__2F650636] FOREIGN KEY([Num_Prop_EM])
REFERENCES [dbo].[Proposta_Exp_Mar] ([Num_Prop_EM])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Mar] CHECK CONSTRAINT [FK__Tarifa_Ne__Num_P__2F650636]
GO
