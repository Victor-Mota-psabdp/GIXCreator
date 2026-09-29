SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tarifa_Neg_Exp_Aer](
	[Num_Prop_EA] [varchar](11) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Org_TNEA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst_TNEA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Via_TNEA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cia_Aer] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Crg_Esp_TNEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Trf_TNEA] [varchar](7) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Ftr_TNEA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Fator_TNEA] [decimal](5, 2) NULL,
	[Trf_Cp_1_TNEA] [decimal](8, 2) NULL,
	[Trf_Vd_1_TNEA] [decimal](8, 2) NULL,
	[Trf_Cp_2_TNEA] [decimal](8, 2) NULL,
	[Trf_Vd_2_TNEA] [decimal](8, 2) NULL,
	[Trf_Cp_3_TNEA] [decimal](8, 2) NULL,
	[Trf_Vd_3_TNEA] [decimal](8, 2) NULL,
	[Trf_Cp_4_TNEA] [decimal](8, 2) NULL,
	[Trf_Vd_4_TNEA] [decimal](8, 2) NULL,
	[Trf_Cp_5_TNEA] [decimal](8, 2) NULL,
	[Trf_Vd_5_TNEA] [decimal](8, 2) NULL,
	[Trf_Cp_6_TNEA] [decimal](8, 2) NULL,
	[Trf_Vd_6_TNEA] [decimal](8, 2) NULL,
	[Trf_Cp_7_TNEA] [decimal](8, 2) NULL,
	[Trf_Vd_7_TNEA] [decimal](8, 2) NULL,
	[Trf_Cp_8_TNEA] [decimal](8, 2) NULL,
	[Trf_Vd_8_TNEA] [decimal](8, 2) NULL,
	[Trst_Time_TNEA] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Freq_TNEA] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Zip_Code_TNEA] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Obs_TNEA] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Prop_EA] ASC,
	[Cd_Org_TNEA] ASC,
	[Cd_Dst_TNEA] ASC,
	[Cd_Via_TNEA] ASC,
	[Cd_Cia_Aer] ASC,
	[Crg_Esp_TNEA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Cia_Aer])
REFERENCES [dbo].[Cia_Aerea] ([Cd_Cia_Aer])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Ds__25DB9BFC] FOREIGN KEY([Cd_Dst_TNEA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Aer] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Ds__25DB9BFC]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Or__26CFC035] FOREIGN KEY([Cd_Org_TNEA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Aer] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Or__26CFC035]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Cd_Vi__28B808A7] FOREIGN KEY([Cd_Via_TNEA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Aer] CHECK CONSTRAINT [FK__Tarifa_Ne__Cd_Vi__28B808A7]
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Tarifa_Ne__Num_P__29AC2CE0] FOREIGN KEY([Num_Prop_EA])
REFERENCES [dbo].[Proposta_Exp_Aer] ([Num_Prop_EA])
GO
ALTER TABLE [dbo].[Tarifa_Neg_Exp_Aer] CHECK CONSTRAINT [FK__Tarifa_Ne__Num_P__29AC2CE0]
GO
