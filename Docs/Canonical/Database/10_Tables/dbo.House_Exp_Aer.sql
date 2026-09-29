SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[House_Exp_Aer](
	[Num_Proc_HEA] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Proc_MEA] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Prop_EA] [varchar](11) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Emis_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[HAWB_HEA] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_HEA] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consig_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Export_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Notify_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Voo_HEA] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Org_HEA] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst_HEA] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[ETD_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[ETA_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Qtd_Tot_Vol_HEA] [decimal](9, 2) NULL,
	[Peso_Real_HEA] [decimal](9, 3) NULL,
	[Trf_Vd_HEA] [decimal](10, 2) NULL,
	[Tp_Frete_HEA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete_Tot_HEA] [decimal](10, 2) NULL,
	[Cd_Tp_Prod] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[RE_DSE_HEA] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[SD_HEA] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Prod_Perig_HEA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Prod_Perec_HEA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Cia_Aer] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Sb_Ag_Nac_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dsp_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[EW_HEA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[FOB_FCA_HEA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[CIF_HEA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cli_Msq_HEA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Transp_HEA] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Vol_Tot_HEA] [decimal](7, 3) NULL,
	[Peso_Bruto_HEA] [float] NULL,
	[Dt_Rcb_Doc_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Etg_Doc_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Obs_HEA] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Oper] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[JOB_HEA] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[HAWB_Instruct] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Tx_Refer_HEA] [float] NULL,
	[Peso_Tax] [float] NULL,
	[Dead_Line] [datetime] NULL,
	[TTime_d] [smallint] NULL,
	[TTime_h] [smallint] NULL,
	[Stand] [bit] NOT NULL,
	[SAP_ShipNumber] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__House_Exp_Aer__45BE5BA9] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HEA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_House_Exp_Aer_01] ON [dbo].[House_Exp_Aer]
(
	[Num_Proc_MEA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[House_Exp_Aer] ADD  CONSTRAINT [DF_House_Exp_Aer_Stand]  DEFAULT (0) FOR [Stand]
GO
ALTER TABLE [dbo].[House_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Ci__6991A7CB] FOREIGN KEY([Cd_Cia_Aer])
REFERENCES [dbo].[Cia_Aerea] ([Cd_Cia_Aer])
GO
ALTER TABLE [dbo].[House_Exp_Aer] CHECK CONSTRAINT [FK__House_Exp__Cd_Ci__6991A7CB]
GO
ALTER TABLE [dbo].[House_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Co__6A85CC04] FOREIGN KEY([Cd_Consig_HEA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Exp_Aer] CHECK CONSTRAINT [FK__House_Exp__Cd_Co__6A85CC04]
GO
ALTER TABLE [dbo].[House_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Ds__6B79F03D] FOREIGN KEY([Cd_Dst_HEA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[House_Exp_Aer] CHECK CONSTRAINT [FK__House_Exp__Cd_Ds__6B79F03D]
GO
ALTER TABLE [dbo].[House_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Ds__6C6E1476] FOREIGN KEY([Cd_Dsp_HEA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Exp_Aer] CHECK CONSTRAINT [FK__House_Exp__Cd_Ds__6C6E1476]
GO
ALTER TABLE [dbo].[House_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Ex__6D6238AF] FOREIGN KEY([Cd_Export_HEA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Exp_Aer] CHECK CONSTRAINT [FK__House_Exp__Cd_Ex__6D6238AF]
GO
ALTER TABLE [dbo].[House_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_No__6E565CE8] FOREIGN KEY([Cd_Notify_HEA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Exp_Aer] CHECK CONSTRAINT [FK__House_Exp__Cd_No__6E565CE8]
GO
ALTER TABLE [dbo].[House_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Or__6F4A8121] FOREIGN KEY([Cd_Org_HEA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[House_Exp_Aer] CHECK CONSTRAINT [FK__House_Exp__Cd_Or__6F4A8121]
GO
ALTER TABLE [dbo].[House_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Sb__703EA55A] FOREIGN KEY([Cd_Sb_Ag_Nac_HEA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Exp_Aer] CHECK CONSTRAINT [FK__House_Exp__Cd_Sb__703EA55A]
GO
ALTER TABLE [dbo].[House_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Tp__7132C993] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[House_Exp_Aer] CHECK CONSTRAINT [FK__House_Exp__Cd_Tp__7132C993]
GO
ALTER TABLE [dbo].[House_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Tp__7226EDCC] FOREIGN KEY([Cd_Tp_Prod])
REFERENCES [dbo].[Tipo_Produto] ([Cd_Tp_Prod])
GO
ALTER TABLE [dbo].[House_Exp_Aer] CHECK CONSTRAINT [FK__House_Exp__Cd_Tp__7226EDCC]
GO
ALTER TABLE [dbo].[House_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Num_P__731B1205] FOREIGN KEY([Num_Proc_MEA])
REFERENCES [dbo].[Master_Exp_Aer] ([Num_Proc_MEA])
GO
ALTER TABLE [dbo].[House_Exp_Aer] CHECK CONSTRAINT [FK__House_Exp__Num_P__731B1205]
GO
ALTER TABLE [dbo].[House_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Num_P__740F363E] FOREIGN KEY([Num_Prop_EA])
REFERENCES [dbo].[Proposta_Exp_Aer] ([Num_Prop_EA])
GO
ALTER TABLE [dbo].[House_Exp_Aer] CHECK CONSTRAINT [FK__House_Exp__Num_P__740F363E]
GO
