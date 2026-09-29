SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Taxa](
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Tp_Tx] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Tp_Tx_Ing] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Ctb_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Item_NF] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[CPMF_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[IRRF_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[ND_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Rateio_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[MEA_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[MEM_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[MIA_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[MIM_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[HEA_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[HEM_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[HIA_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[HIM_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Pft_Aer] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Pft_Mar] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desat_Tx] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_cta_ctb_atv] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Cd_cta_ctb_pas] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Tx_Ofc] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Isent_CPMF] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Repasse_Tx] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[NF] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[CodigoTP] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_DC] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Rentabilidade] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Tx_Sis] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[CD_AX] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[CD_AX_Resultado] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_AX_Repasse] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Prod_Code] [char](1) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK__Tipo_Taxa__1332DBDC] PRIMARY KEY CLUSTERED 
(
	[Cd_Tp_Tx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__Tipo_Taxa__04AFB25B] UNIQUE NONCLUSTERED 
(
	[Nome_Tp_Tx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Tipo_Taxa] ADD  CONSTRAINT [DF_Tipo_Taxa_Isent_CPMF]  DEFAULT ('N') FOR [Isent_CPMF]
GO
ALTER TABLE [dbo].[Tipo_Taxa]  WITH CHECK ADD  CONSTRAINT [FK__Tipo_Taxa__Cd_Tp__1B9317B3] FOREIGN KEY([Cd_Tp_Item_NF])
REFERENCES [dbo].[Tipo_Item_Nota_Fiscal] ([Cd_Tp_Item_NF])
GO
ALTER TABLE [dbo].[Tipo_Taxa] CHECK CONSTRAINT [FK__Tipo_Taxa__Cd_Tp__1B9317B3]
GO
ALTER TABLE [dbo].[Tipo_Taxa]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Taxa_Cta_Ctb] FOREIGN KEY([Cd_cta_ctb_atv])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[Tipo_Taxa] CHECK CONSTRAINT [FK_Tipo_Taxa_Cta_Ctb]
GO
ALTER TABLE [dbo].[Tipo_Taxa]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Taxa_Cta_Ctb1] FOREIGN KEY([Cd_cta_ctb_pas])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[Tipo_Taxa] CHECK CONSTRAINT [FK_Tipo_Taxa_Cta_Ctb1]
GO
