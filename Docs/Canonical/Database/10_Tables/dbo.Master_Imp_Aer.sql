SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Master_Imp_Aer](
	[Num_Proc_MIA] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Emis_MIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_MIA] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Termo_MIA] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Voo_MIA] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consig_MIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Export_MIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Org_MIA] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst_MIA] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Cheg_MIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Qtd_Tot_Vol_MIA] [decimal](4, 0) NULL,
	[Peso_Bruto_MIA] [decimal](9, 3) NULL,
	[Tp_Frete_MIA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete_MIA] [decimal](10, 2) NULL,
	[Qtd_HAWB_MIA] [varchar](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ref_Int_MIA] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Nivel_DL] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Obs_MIA] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Cia_Aer] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Proc_MIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Master_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Cd_Co__0FEC5ADD] FOREIGN KEY([Cd_Consig_MIA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Master_Imp_Aer] CHECK CONSTRAINT [FK__Master_Im__Cd_Co__0FEC5ADD]
GO
ALTER TABLE [dbo].[Master_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Cd_Ds__10E07F16] FOREIGN KEY([Cd_Dst_MIA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Master_Imp_Aer] CHECK CONSTRAINT [FK__Master_Im__Cd_Ds__10E07F16]
GO
ALTER TABLE [dbo].[Master_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Cd_Ex__11D4A34F] FOREIGN KEY([Cd_Export_MIA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Master_Imp_Aer] CHECK CONSTRAINT [FK__Master_Im__Cd_Ex__11D4A34F]
GO
ALTER TABLE [dbo].[Master_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Cd_Or__12C8C788] FOREIGN KEY([Cd_Org_MIA])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Master_Imp_Aer] CHECK CONSTRAINT [FK__Master_Im__Cd_Or__12C8C788]
GO
ALTER TABLE [dbo].[Master_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Master_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Nivel_DL])
REFERENCES [dbo].[Div_Lucro] ([Nivel_DL])
GO
ALTER TABLE [dbo].[Master_Imp_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Master_Imp_Aer_Cia_Aerea] FOREIGN KEY([Cd_Cia_Aer])
REFERENCES [dbo].[Cia_Aerea] ([Cd_Cia_Aer])
GO
ALTER TABLE [dbo].[Master_Imp_Aer] CHECK CONSTRAINT [FK_Master_Imp_Aer_Cia_Aerea]
GO
