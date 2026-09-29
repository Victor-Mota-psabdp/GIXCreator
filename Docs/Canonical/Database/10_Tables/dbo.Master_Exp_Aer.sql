SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Master_Exp_Aer](
	[Num_Proc_MEA] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Emis_MEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_MEA] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Voo_MEA] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Saida_MEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consig_MEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Export_MEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Org_MEA] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst_MEA] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Gat_MEA] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Cia_Aer] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Trf_Net_MEA] [decimal](10, 2) NULL,
	[Qtd_Tot_Vol_MEA] [decimal](4, 0) NULL,
	[Peso_Bruto_MEA] [decimal](9, 3) NULL,
	[Tp_Frete_MEA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete_MEA] [decimal](10, 2) NULL,
	[Qtd_HAWB_MEA] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nivel_DL] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Obs_MEA] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Tx_Refer_MEA] [float] NULL,
	[Peso_Tax_MEA] [float] NULL,
	[Refer_Cons_MEA] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Impres_MEA] [datetime] NULL,
	[Consig_Acc_MEA] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[ETA_MEA] [datetime] NULL,
	[ETD_MEA] [datetime] NULL,
	[dt_ImpressDraft_mea] [datetime] NULL,
	[Vol_Tot_MEA] [decimal](7, 3) NULL,
	[cd_User_Impres_mea] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__Master_Exp_Aer__30C33EC3] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_MEA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Master_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Cd_Ci__02925FBF] FOREIGN KEY([Cd_Cia_Aer])
REFERENCES [dbo].[Cia_Aerea] ([Cd_Cia_Aer])
GO
ALTER TABLE [dbo].[Master_Exp_Aer] CHECK CONSTRAINT [FK__Master_Ex__Cd_Ci__02925FBF]
GO
ALTER TABLE [dbo].[Master_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Cd_Co__038683F8] FOREIGN KEY([Cd_Consig_MEA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Master_Exp_Aer] CHECK CONSTRAINT [FK__Master_Ex__Cd_Co__038683F8]
GO
ALTER TABLE [dbo].[Master_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Cd_Ds__047AA831] FOREIGN KEY([Cd_Dst_MEA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Master_Exp_Aer] CHECK CONSTRAINT [FK__Master_Ex__Cd_Ds__047AA831]
GO
ALTER TABLE [dbo].[Master_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Cd_Ex__056ECC6A] FOREIGN KEY([Cd_Export_MEA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Master_Exp_Aer] CHECK CONSTRAINT [FK__Master_Ex__Cd_Ex__056ECC6A]
GO
ALTER TABLE [dbo].[Master_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Cd_Or__0662F0A3] FOREIGN KEY([Cd_Org_MEA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Master_Exp_Aer] CHECK CONSTRAINT [FK__Master_Ex__Cd_Or__0662F0A3]
GO
ALTER TABLE [dbo].[Master_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Cd_Tp__075714DC] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Master_Exp_Aer] CHECK CONSTRAINT [FK__Master_Ex__Cd_Tp__075714DC]
GO
ALTER TABLE [dbo].[Master_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Nivel__084B3915] FOREIGN KEY([Nivel_DL])
REFERENCES [dbo].[Div_Lucro] ([Nivel_DL])
GO
ALTER TABLE [dbo].[Master_Exp_Aer] CHECK CONSTRAINT [FK__Master_Ex__Nivel__084B3915]
GO
ALTER TABLE [dbo].[Master_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Master_Exp_Aer_Localidade] FOREIGN KEY([Cd_Gat_MEA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Master_Exp_Aer] CHECK CONSTRAINT [FK_Master_Exp_Aer_Localidade]
GO
