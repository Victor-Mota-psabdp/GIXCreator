SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[House_Imp_Mar](
	[Num_Proc_HIM] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Proc_MIM] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Prop_IM] [varchar](11) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Emis_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[HAWB_HIM] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_HIM] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Import_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consig_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Export_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Navio_HIM] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Viagem_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Id_Viagem] [int] NULL,
	[Band_Bras_HIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Org_HIM] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst_HIM] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Saida_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Cheg_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Tp_Frete_HIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete_Efet_HIM] [decimal](10, 2) NULL,
	[Prod_Perig_HIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Prod_Perec_HIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Sb_Ag_Int_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Sb_Ag_Nac_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Prod] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[EW_HIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[FOB_FCA_HIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[CIF_HIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cli_Msq_HIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Porto_Rcb_HIM] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Emissor] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Embal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Qtd_Tot_Vol_HIM] [decimal](9, 2) NULL,
	[Vol_Tot_HIM] [decimal](7, 3) NULL,
	[Peso_Liquido_HIM] [float] NULL,
	[Peso_Bruto_HIM] [float] NULL,
	[Tp_Trf_HIM] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Trf_Cp_HIM] [decimal](10, 2) NULL,
	[Trf_Vd_HIM] [decimal](10, 2) NULL,
	[Vlr_Frete_Negoc_HIM] [decimal](10, 2) NULL,
	[Dt_Rcb_Doc_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Etg_Doc_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Obs_HIM] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Transito_HIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Oper] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[JOB_HIM] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Despachante] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dead_Line] [datetime] NULL,
	[TTime_d] [smallint] NULL,
	[TTime_h] [smallint] NULL,
	[Stand] [bit] NOT NULL,
	[SAP_ShipNumber] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__House_Imp_Mar__489AC854] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HIM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_House_Imp_Mar_01] ON [dbo].[House_Imp_Mar]
(
	[Num_Proc_MIM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[House_Imp_Mar] ADD  CONSTRAINT [DF_House_Imp_Mar_Stand]  DEFAULT (0) FOR [Stand]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Co__0CDAE408] FOREIGN KEY([Cd_Consig_HIM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Cd_Co__0CDAE408]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Ds__0DCF0841] FOREIGN KEY([Cd_Dst_HIM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Cd_Ds__0DCF0841]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Ex__0EC32C7A] FOREIGN KEY([Cd_Export_HIM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Cd_Ex__0EC32C7A]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Im__0FB750B3] FOREIGN KEY([Cd_Import_HIM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Cd_Im__0FB750B3]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Or__10AB74EC] FOREIGN KEY([Cd_Org_HIM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Cd_Or__10AB74EC]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Po__119F9925] FOREIGN KEY([Cd_Porto_Rcb_HIM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Cd_Po__119F9925]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Sb__1293BD5E] FOREIGN KEY([Cd_Sb_Ag_Int_HIM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Cd_Sb__1293BD5E]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Sb__1387E197] FOREIGN KEY([Cd_Sb_Ag_Nac_HIM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Cd_Sb__1387E197]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Tp__147C05D0] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Cd_Tp__147C05D0]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Tp__15702A09] FOREIGN KEY([Cd_Tp_Prod])
REFERENCES [dbo].[Tipo_Produto] ([Cd_Tp_Prod])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Cd_Tp__15702A09]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Tp__16644E42] FOREIGN KEY([Cd_Tp_Embal])
REFERENCES [dbo].[Tipo_Embalagem] ([Cd_Tp_Embal])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Cd_Tp__16644E42]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Num_P__1758727B] FOREIGN KEY([Num_Prop_IM])
REFERENCES [dbo].[Proposta_Imp_Mar] ([Num_Prop_IM])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Num_P__1758727B]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Num_P__54D68207] FOREIGN KEY([Num_Proc_MIM])
REFERENCES [dbo].[Master_Imp_Mar] ([Num_Proc_MIM])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK__House_Imp__Num_P__54D68207]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_House_Imp_Mar_Aux_Armador] FOREIGN KEY([Cd_Emissor])
REFERENCES [dbo].[Aux_Armador] ([Cd_Arm_Ofc])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK_House_Imp_Mar_Aux_Armador]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_House_Imp_Mar_Pessoa] FOREIGN KEY([Cd_Despachante])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK_House_Imp_Mar_Pessoa]
GO
ALTER TABLE [dbo].[House_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_House_Imp_Mar_Viagem] FOREIGN KEY([Id_Viagem])
REFERENCES [dbo].[Viagem] ([ID_Viagem])
GO
ALTER TABLE [dbo].[House_Imp_Mar] CHECK CONSTRAINT [FK_House_Imp_Mar_Viagem]
GO
