SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[House_Imp_Aer](
	[Num_Proc_HIA] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Proc_MIA] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Prop_IA] [varchar](11) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Emis_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Etapa] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[HAWB_HIA] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_HIA] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Import_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consig_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Export_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Voo_HIA] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Org_HIA] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst_HIA] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[ETD_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[ETA_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Qtd_Tot_Vol_HIA] [decimal](9, 2) NULL,
	[Peso_Real_HIA] [float] NULL,
	[Tp_Frete_HIA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete_Efet_HIA] [decimal](10, 2) NULL,
	[Back_Back_HIA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Sb_Ag_Int_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Sb_Ag_Nac_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Prod] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Prod_Perig_HIA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Prod_Perec_HIA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dsp_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cli_Msq_HIA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Pri_Avs_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Seg_Avs_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[EW_HIA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[FOB_FCA_HIA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[CIF_HIA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vol_Tot_HIA] [decimal](7, 3) NULL,
	[Peso_Bruto_HIA] [float] NULL,
	[Tp_Trf_HIA] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Trf_Cp_HIA] [decimal](10, 2) NULL,
	[Trf_Vd_HIA] [decimal](10, 2) NULL,
	[Vlr_Frete_Negoc_HIA] [decimal](10, 2) NULL,
	[Dt_Rcb_Doc_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Etg_Doc_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Obs_HIA] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Oper] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[JOB_HIA] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Dead_Line] [datetime] NULL,
	[TTime_d] [smallint] NULL,
	[TTime_h] [smallint] NULL,
	[Stand] [bit] NOT NULL,
	[SAP_ShipNumber] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__House_Imp_Aer__47A6A41B] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_House_Imp_Aer_01] ON [dbo].[House_Imp_Aer]
(
	[Num_Proc_MIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[House_Imp_Aer] ADD  CONSTRAINT [DF_House_Imp_Aer_Stand]  DEFAULT (0) FOR [Stand]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Co__00750D23] FOREIGN KEY([Cd_Consig_HIA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Cd_Co__00750D23]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Ds__0169315C] FOREIGN KEY([Cd_Dsp_HIA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Cd_Ds__0169315C]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Ds__025D5595] FOREIGN KEY([Cd_Dst_HIA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Cd_Ds__025D5595]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Ex__035179CE] FOREIGN KEY([Cd_Export_HIA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Cd_Ex__035179CE]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Im__04459E07] FOREIGN KEY([Cd_Import_HIA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Cd_Im__04459E07]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Or__0539C240] FOREIGN KEY([Cd_Org_HIA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Cd_Or__0539C240]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Sb__062DE679] FOREIGN KEY([Cd_Sb_Ag_Int_HIA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Cd_Sb__062DE679]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Sb__07220AB2] FOREIGN KEY([Cd_Sb_Ag_Nac_HIA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Cd_Sb__07220AB2]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Tp__08162EEB] FOREIGN KEY([Cd_Tp_Etapa])
REFERENCES [dbo].[Tipo_Etapa] ([Cd_Tp_Etapa])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Cd_Tp__08162EEB]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Tp__090A5324] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Cd_Tp__090A5324]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Cd_Tp__09FE775D] FOREIGN KEY([Cd_Tp_Prod])
REFERENCES [dbo].[Tipo_Produto] ([Cd_Tp_Prod])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Cd_Tp__09FE775D]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Num_P__0AF29B96] FOREIGN KEY([Num_Prop_IA])
REFERENCES [dbo].[Proposta_Imp_Aer] ([Num_Prop_IA])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Num_P__0AF29B96]
GO
ALTER TABLE [dbo].[House_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Imp__Num_P__0BE6BFCF] FOREIGN KEY([Num_Proc_MIA])
REFERENCES [dbo].[Master_Imp_Aer] ([Num_Proc_MIA])
GO
ALTER TABLE [dbo].[House_Imp_Aer] CHECK CONSTRAINT [FK__House_Imp__Num_P__0BE6BFCF]
GO
