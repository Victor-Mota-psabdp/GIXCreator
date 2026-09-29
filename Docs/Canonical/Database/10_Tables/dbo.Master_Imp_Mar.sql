SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Master_Imp_Mar](
	[Num_Proc_MIM] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Emis_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Saida_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Atrac_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Oper_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Desova_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Rcb_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Reg_Alf_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Reg_Alf_MIM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[CIMC_MIM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_MIM] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Sub_Master_MIM] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Sub_Master_Col_MIM] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consig_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Export_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Org_MIM] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst_MIM] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Armador] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Armador_SM] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Transb_MIM] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Navio_Transb_MIM] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Navio_MIM] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Viagem_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[ID_Viagem] [int] NULL,
	[IRIN_MIM] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Cod_Rec_MIM] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Armazem] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Terminal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Qtd_Tot_Vol_MIM] [decimal](4, 0) NULL,
	[Vol_Tot_MIM] [decimal](7, 3) NULL,
	[Peso_Bruto_MIM] [decimal](12, 3) NULL,
	[Tp_Frete_MIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete_MIM] [decimal](10, 2) NULL,
	[Qtd_HAWB_MIM] [char](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Ref_Int_MIM] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Nivel_DL] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Obs_MIM] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ent_Term] [datetime] NULL,
	[Dt_Lib_BL] [datetime] NULL,
	[AWB] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Rec_Doc] [datetime] NULL,
	[Dt_Doc_Camb] [datetime] NULL,
	[DtRedest_MIM] [datetime] NULL,
 CONSTRAINT [PK__Master_Imp_Mar__51FA155C] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_MIM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [XIE1Master_Imp_Mar] ON [dbo].[Master_Imp_Mar]
(
	[MAWB_MIM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Master_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Cd_Ar__57B2EEB2] FOREIGN KEY([Cd_Armazem])
REFERENCES [dbo].[Armazem] ([Cd_Armazem])
GO
ALTER TABLE [dbo].[Master_Imp_Mar] CHECK CONSTRAINT [FK__Master_Im__Cd_Ar__57B2EEB2]
GO
ALTER TABLE [dbo].[Master_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Cd_Co__5B837F96] FOREIGN KEY([Cd_Consig_MIM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Master_Imp_Mar] CHECK CONSTRAINT [FK__Master_Im__Cd_Co__5B837F96]
GO
ALTER TABLE [dbo].[Master_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Cd_Ds__5D6BC808] FOREIGN KEY([Cd_Dst_MIM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Master_Imp_Mar] CHECK CONSTRAINT [FK__Master_Im__Cd_Ds__5D6BC808]
GO
ALTER TABLE [dbo].[Master_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Cd_Ex__5C77A3CF] FOREIGN KEY([Cd_Export_MIM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Master_Imp_Mar] CHECK CONSTRAINT [FK__Master_Im__Cd_Ex__5C77A3CF]
GO
ALTER TABLE [dbo].[Master_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Cd_Or__55CAA640] FOREIGN KEY([Cd_Org_MIM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Master_Imp_Mar] CHECK CONSTRAINT [FK__Master_Im__Cd_Or__55CAA640]
GO
ALTER TABLE [dbo].[Master_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Cd_Te__58A712EB] FOREIGN KEY([Cd_Terminal])
REFERENCES [dbo].[Terminal] ([Cd_Terminal])
GO
ALTER TABLE [dbo].[Master_Imp_Mar] CHECK CONSTRAINT [FK__Master_Im__Cd_Te__58A712EB]
GO
ALTER TABLE [dbo].[Master_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Cd_Tp__599B3724] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Master_Imp_Mar] CHECK CONSTRAINT [FK__Master_Im__Cd_Tp__599B3724]
GO
ALTER TABLE [dbo].[Master_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Cd_Tr__56BECA79] FOREIGN KEY([Cd_Transb_MIM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Master_Imp_Mar] CHECK CONSTRAINT [FK__Master_Im__Cd_Tr__56BECA79]
GO
ALTER TABLE [dbo].[Master_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Im__Nivel__5F54107A] FOREIGN KEY([Nivel_DL])
REFERENCES [dbo].[Div_Lucro] ([Nivel_DL])
GO
ALTER TABLE [dbo].[Master_Imp_Mar] CHECK CONSTRAINT [FK__Master_Im__Nivel__5F54107A]
GO
ALTER TABLE [dbo].[Master_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Master_Imp_Mar_Viagem] FOREIGN KEY([ID_Viagem])
REFERENCES [dbo].[Viagem] ([ID_Viagem])
GO
ALTER TABLE [dbo].[Master_Imp_Mar] CHECK CONSTRAINT [FK_Master_Imp_Mar_Viagem]
GO
