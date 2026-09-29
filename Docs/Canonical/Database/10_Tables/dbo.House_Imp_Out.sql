SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[House_Imp_Out](
	[Num_Proc_HIO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Emis_HIO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_tp_Etapa] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[HAWB_HIO] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_HIO] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Import_HIO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Consig_HIO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Export_HIO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Voo_HIO] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Org_HIO] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst_HIO] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Qtd_Tot_Vol_HIO] [decimal](9, 2) NULL,
	[Peso_Real_HIO] [float] NULL,
	[Peso_Bruto_HIO] [float] NULL,
	[Vol_Tot_HIO] [decimal](7, 3) NULL,
	[Tp_Frete_HIO] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete_Efet_HIO] [decimal](10, 2) NULL,
	[Cd_Tp_Oper] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Obs_HIO] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Sap_ShipNumber] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[TTime_d] [smallint] NULL,
 CONSTRAINT [PK_House_Imp_Outros] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[House_Imp_Out]  WITH NOCHECK ADD  CONSTRAINT [FK_House_Imp_Outros_Localidade] FOREIGN KEY([Cd_Org_HIO])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[House_Imp_Out] CHECK CONSTRAINT [FK_House_Imp_Outros_Localidade]
GO
ALTER TABLE [dbo].[House_Imp_Out]  WITH NOCHECK ADD  CONSTRAINT [FK_House_Imp_Outros_Localidade1] FOREIGN KEY([Cd_Dst_HIO])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[House_Imp_Out] CHECK CONSTRAINT [FK_House_Imp_Outros_Localidade1]
GO
ALTER TABLE [dbo].[House_Imp_Out]  WITH NOCHECK ADD  CONSTRAINT [FK_House_Imp_Outros_Pessoa] FOREIGN KEY([Cd_Import_HIO])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Out] CHECK CONSTRAINT [FK_House_Imp_Outros_Pessoa]
GO
ALTER TABLE [dbo].[House_Imp_Out]  WITH NOCHECK ADD  CONSTRAINT [FK_House_Imp_Outros_Pessoa1] FOREIGN KEY([Cd_Consig_HIO])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Out] CHECK CONSTRAINT [FK_House_Imp_Outros_Pessoa1]
GO
ALTER TABLE [dbo].[House_Imp_Out]  WITH NOCHECK ADD  CONSTRAINT [FK_House_Imp_Outros_Pessoa2] FOREIGN KEY([Cd_Export_HIO])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[House_Imp_Out] CHECK CONSTRAINT [FK_House_Imp_Outros_Pessoa2]
GO
ALTER TABLE [dbo].[House_Imp_Out]  WITH NOCHECK ADD  CONSTRAINT [FK_House_Imp_Outros_Tipo_Moeda] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[House_Imp_Out] CHECK CONSTRAINT [FK_House_Imp_Outros_Tipo_Moeda]
GO
ALTER TABLE [dbo].[House_Imp_Out]  WITH NOCHECK ADD  CONSTRAINT [FK_House_Imp_Outros_Tipo_Oper] FOREIGN KEY([Cd_Tp_Oper])
REFERENCES [dbo].[Tipo_Oper] ([Cd_Tp_Oper])
GO
ALTER TABLE [dbo].[House_Imp_Out] CHECK CONSTRAINT [FK_House_Imp_Outros_Tipo_Oper]
GO
