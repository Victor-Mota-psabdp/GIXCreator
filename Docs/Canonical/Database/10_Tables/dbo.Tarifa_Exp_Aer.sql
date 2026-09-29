SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tarifa_Exp_Aer](
	[Cd_Org_TEA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst_TEA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Via_TEA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cia_Aer] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Crg_Esp_TEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Trf_TEA] [varchar](7) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Ftr_TEA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Fator_TEA] [decimal](5, 2) NULL,
	[Trf_Cp_1_TEA] [decimal](8, 2) NULL,
	[Trf_Vd_1_TEA] [decimal](8, 2) NULL,
	[Trf_Cp_2_TEA] [decimal](8, 2) NULL,
	[Trf_Vd_2_TEA] [decimal](8, 2) NULL,
	[Trf_Cp_3_TEA] [decimal](8, 2) NULL,
	[Trf_Vd_3_TEA] [decimal](8, 2) NULL,
	[Trf_Cp_4_TEA] [decimal](8, 2) NULL,
	[Trf_Vd_4_TEA] [decimal](8, 2) NULL,
	[Trf_Cp_5_TEA] [decimal](8, 2) NULL,
	[Trf_Vd_5_TEA] [decimal](8, 2) NULL,
	[Trf_Cp_6_TEA] [decimal](8, 2) NULL,
	[Trf_Vd_6_TEA] [decimal](8, 2) NULL,
	[Trf_Cp_7_TEA] [decimal](8, 2) NULL,
	[Trf_Vd_7_TEA] [decimal](8, 2) NULL,
	[Trf_Cp_8_TEA] [decimal](8, 2) NULL,
	[Trf_Vd_8_TEA] [decimal](8, 2) NULL,
	[Trst_Time_TEA] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Freq_TEA] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Val_TEA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Obs_TEA] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Cd_Org_TEA] ASC,
	[Cd_Dst_TEA] ASC,
	[Cd_Via_TEA] ASC,
	[Cd_Cia_Aer] ASC,
	[Crg_Esp_TEA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tarifa_Exp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Cia_Aer])
REFERENCES [dbo].[Cia_Aerea] ([Cd_Cia_Aer])
GO
ALTER TABLE [dbo].[Tarifa_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ex__Cd_Ds__2CBDA3B5] FOREIGN KEY([Cd_Dst_TEA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Exp_Aer] CHECK CONSTRAINT [FK__Tarifa_Ex__Cd_Ds__2CBDA3B5]
GO
ALTER TABLE [dbo].[Tarifa_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ex__Cd_Or__2DB1C7EE] FOREIGN KEY([Cd_Org_TEA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Exp_Aer] CHECK CONSTRAINT [FK__Tarifa_Ex__Cd_Or__2DB1C7EE]
GO
ALTER TABLE [dbo].[Tarifa_Exp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Tarifa_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ex__Cd_Vi__2F9A1060] FOREIGN KEY([Cd_Via_TEA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Exp_Aer] CHECK CONSTRAINT [FK__Tarifa_Ex__Cd_Vi__2F9A1060]
GO
