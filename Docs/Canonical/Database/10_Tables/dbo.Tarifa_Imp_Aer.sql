SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tarifa_Imp_Aer](
	[Cd_Org_TIA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst_TIA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Via_TIA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cia_Aer] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Crg_Esp_TIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Trf_TIA] [varchar](7) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Ftr_TIA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Fator_TIA] [decimal](5, 2) NULL,
	[Trf_Cp_1_TIA] [decimal](8, 2) NULL,
	[Trf_Vd_1_TIA] [decimal](8, 2) NULL,
	[Trf_Cp_2_TIA] [decimal](8, 2) NULL,
	[Trf_Vd_2_TIA] [decimal](8, 2) NULL,
	[Trf_Cp_3_TIA] [decimal](8, 2) NULL,
	[Trf_Vd_3_TIA] [decimal](8, 2) NULL,
	[Trf_Cp_4_TIA] [decimal](8, 2) NULL,
	[Trf_Vd_4_TIA] [decimal](8, 2) NULL,
	[Trf_Cp_5_TIA] [decimal](8, 2) NULL,
	[Trf_Vd_5_TIA] [decimal](8, 2) NULL,
	[Trf_Cp_6_TIA] [decimal](8, 2) NULL,
	[Trf_Vd_6_TIA] [decimal](8, 2) NULL,
	[Trf_Cp_7_TIA] [decimal](8, 2) NULL,
	[Trf_Vd_7_TIA] [decimal](8, 2) NULL,
	[Trf_Cp_8_TIA] [decimal](8, 2) NULL,
	[Trf_Vd_8_TIA] [decimal](8, 2) NULL,
	[Trst_Time_TIA] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Freq_TIA] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Val_TIA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Obs_TIA] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Cd_Org_TIA] ASC,
	[Cd_Dst_TIA] ASC,
	[Cd_Via_TIA] ASC,
	[Cd_Cia_Aer] ASC,
	[Crg_Esp_TIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tarifa_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Cia_Aer])
REFERENCES [dbo].[Cia_Aerea] ([Cd_Cia_Aer])
GO
ALTER TABLE [dbo].[Tarifa_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Im__Cd_Ds__36470DEF] FOREIGN KEY([Cd_Dst_TIA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Imp_Aer] CHECK CONSTRAINT [FK__Tarifa_Im__Cd_Ds__36470DEF]
GO
ALTER TABLE [dbo].[Tarifa_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Im__Cd_Or__373B3228] FOREIGN KEY([Cd_Org_TIA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Imp_Aer] CHECK CONSTRAINT [FK__Tarifa_Im__Cd_Or__373B3228]
GO
ALTER TABLE [dbo].[Tarifa_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Tarifa_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Im__Cd_Vi__39237A9A] FOREIGN KEY([Cd_Via_TIA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Imp_Aer] CHECK CONSTRAINT [FK__Tarifa_Im__Cd_Vi__39237A9A]
GO
