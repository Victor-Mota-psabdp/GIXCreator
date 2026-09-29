SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tarifa_Neg_Imp_Aer](
	[Num_Prop_IA] [varchar](11) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Org_TNIA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst_TNIA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Via_TNIA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cia_Aer] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Crg_Esp_TNIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Trf_TNIA] [varchar](7) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Ftr_TNIA] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Fator_TNIA] [decimal](5, 2) NULL,
	[Trf_Cp_1_TNIA] [decimal](8, 2) NULL,
	[Trf_Vd_1_TNIA] [decimal](8, 2) NULL,
	[Trf_Cp_2_TNIA] [decimal](8, 2) NULL,
	[Trf_Vd_2_TNIA] [decimal](8, 2) NULL,
	[Trf_Cp_3_TNIA] [decimal](8, 2) NULL,
	[Trf_Vd_3_TNIA] [decimal](8, 2) NULL,
	[Trf_Cp_4_TNIA] [decimal](8, 2) NULL,
	[Trf_Vd_4_TNIA] [decimal](8, 2) NULL,
	[Trf_Cp_5_TNIA] [decimal](8, 2) NULL,
	[Trf_Vd_5_TNIA] [decimal](8, 2) NULL,
	[Trf_Cp_6_TNIA] [decimal](8, 2) NULL,
	[Trf_Vd_6_TNIA] [decimal](8, 2) NULL,
	[Trf_Cp_7_TNIA] [decimal](8, 2) NULL,
	[Trf_Vd_7_TNIA] [decimal](8, 2) NULL,
	[Trf_Cp_8_TNIA] [decimal](8, 2) NULL,
	[Trf_Vd_8_TNIA] [decimal](8, 2) NULL,
	[Trst_Time_TNIA] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Freq_TNIA] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Zip_Code_TNIA] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Obs_TNIA] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Prop_IA] ASC,
	[Cd_Org_TNIA] ASC,
	[Cd_Dst_TNIA] ASC,
	[Cd_Via_TNIA] ASC,
	[Cd_Cia_Aer] ASC,
	[Crg_Esp_TNIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Cia_Aer])
REFERENCES [dbo].[Cia_Aerea] ([Cd_Cia_Aer])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Ds__314D4EA8] FOREIGN KEY([Cd_Dst_TNIA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Aer] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Ds__314D4EA8]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Or__324172E1] FOREIGN KEY([Cd_Org_TNIA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Aer] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Or__324172E1]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Vi__3429BB53] FOREIGN KEY([Cd_Via_TNIA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Aer] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Vi__3429BB53]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Num_P__351DDF8C] FOREIGN KEY([Num_Prop_IA])
REFERENCES [dbo].[Proposta_Imp_Aer] ([Num_Prop_IA])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Imp_Aer] CHECK CONSTRAINT [FK__Tarifa_Ne__Num_P__351DDF8C]
GO
