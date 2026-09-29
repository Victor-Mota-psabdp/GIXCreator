SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[House_Exp_Mar](
	[Num_Proc_HEM] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Proc_MEM] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Prop_EM] [varchar](11) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Emis_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Etg_BL_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[HAWB_HEM] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_HEM] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consig_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Export_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Notify_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Navio_HEM] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Viagem_HEM] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Id_Viagem] [int] NULL,
	[Band_Bras_HEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Org_HEM] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst_HEM] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Sb_Ag_Nac_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Trf_Vd_HEM] [decimal](10, 2) NULL,
	[Trf_Cp_HEM] [decimal](10, 2) NULL,
	[Tp_Frete_HEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete_Tot_HEM] [decimal](10, 2) NULL,
	[Cd_Tp_Prod] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[RE_DSE_HEM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[SD_HEM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Prod_Perig_HEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Prod_Perec_HEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dsp_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cli_Msq_HEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Transp_HEM] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[EW_HEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[FOB_FCA_HEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[CIF_HEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Embal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Qtd_Tot_Vol_HEM] [decimal](9, 2) NULL,
	[Vol_Tot_HEM] [decimal](7, 3) NULL,
	[Peso_Liquido_HEM] [float] NULL,
	[Peso_Bruto_HEM] [float] NULL,
	[Dt_Rcb_Crg_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Rcb_Doc_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Obs_HEM] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Transito_HEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Emissor] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Oper] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[JOB_HEM] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Dead_Line] [datetime] NULL,
	[TTime_h] [smallint] NULL,
	[TTime_d] [smallint] NULL,
	[Stand] [bit] NOT NULL,
	[SAP_ShipNumber] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[CourrierCode] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__House_Exp_Mar__46B27FE2] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HEM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_House_Exp_Mar_01] ON [dbo].[House_Exp_Mar]
(
	[Num_Proc_MEM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[House_Exp_Mar] ADD  CONSTRAINT [DF_House_Exp_Mar_Stand]  DEFAULT (0) FOR [Stand]
GO
ALTER TABLE [dbo].[House_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Co__75035A77] FOREIGN KEY([Cd_Consig_HEM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Exp_Mar] CHECK CONSTRAINT [FK__House_Exp__Cd_Co__75035A77]
GO
ALTER TABLE [dbo].[House_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Ds__76EBA2E9] FOREIGN KEY([Cd_Dsp_HEM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Exp_Mar] CHECK CONSTRAINT [FK__House_Exp__Cd_Ds__76EBA2E9]
GO
ALTER TABLE [dbo].[House_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Ex__77DFC722] FOREIGN KEY([Cd_Export_HEM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Exp_Mar] CHECK CONSTRAINT [FK__House_Exp__Cd_Ex__77DFC722]
GO
ALTER TABLE [dbo].[House_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_No__78D3EB5B] FOREIGN KEY([Cd_Notify_HEM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Exp_Mar] CHECK CONSTRAINT [FK__House_Exp__Cd_No__78D3EB5B]
GO
ALTER TABLE [dbo].[House_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Sb__7ABC33CD] FOREIGN KEY([Cd_Sb_Ag_Nac_HEM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Exp_Mar] CHECK CONSTRAINT [FK__House_Exp__Cd_Sb__7ABC33CD]
GO
ALTER TABLE [dbo].[House_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Tp__7BB05806] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[House_Exp_Mar] CHECK CONSTRAINT [FK__House_Exp__Cd_Tp__7BB05806]
GO
ALTER TABLE [dbo].[House_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Tp__7CA47C3F] FOREIGN KEY([Cd_Tp_Prod])
REFERENCES [dbo].[Tipo_Produto] ([Cd_Tp_Prod])
GO
ALTER TABLE [dbo].[House_Exp_Mar] CHECK CONSTRAINT [FK__House_Exp__Cd_Tp__7CA47C3F]
GO
ALTER TABLE [dbo].[House_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Cd_Tp__7D98A078] FOREIGN KEY([Cd_Tp_Embal])
REFERENCES [dbo].[Tipo_Embalagem] ([Cd_Tp_Embal])
GO
ALTER TABLE [dbo].[House_Exp_Mar] CHECK CONSTRAINT [FK__House_Exp__Cd_Tp__7D98A078]
GO
ALTER TABLE [dbo].[House_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Num_P__7E8CC4B1] FOREIGN KEY([Num_Proc_MEM])
REFERENCES [dbo].[Master_Exp_Mar] ([Num_Proc_MEM])
GO
ALTER TABLE [dbo].[House_Exp_Mar] CHECK CONSTRAINT [FK__House_Exp__Num_P__7E8CC4B1]
GO
ALTER TABLE [dbo].[House_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__House_Exp__Num_P__7F80E8EA] FOREIGN KEY([Num_Prop_EM])
REFERENCES [dbo].[Proposta_Exp_Mar] ([Num_Prop_EM])
GO
ALTER TABLE [dbo].[House_Exp_Mar] CHECK CONSTRAINT [FK__House_Exp__Num_P__7F80E8EA]
GO
ALTER TABLE [dbo].[House_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_House_Exp_Mar_Aux_Armador] FOREIGN KEY([Cd_Emissor])
REFERENCES [dbo].[Aux_Armador] ([Cd_Arm_Ofc])
GO
ALTER TABLE [dbo].[House_Exp_Mar] CHECK CONSTRAINT [FK_House_Exp_Mar_Aux_Armador]
GO
ALTER TABLE [dbo].[House_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_House_Exp_Mar_Viagem] FOREIGN KEY([Id_Viagem])
REFERENCES [dbo].[Viagem] ([ID_Viagem])
GO
ALTER TABLE [dbo].[House_Exp_Mar] CHECK CONSTRAINT [FK_House_Exp_Mar_Viagem]
GO
