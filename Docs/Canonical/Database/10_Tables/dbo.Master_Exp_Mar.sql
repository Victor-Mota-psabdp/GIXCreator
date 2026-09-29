SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Master_Exp_Mar](
	[Num_Proc_MEM] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Emis_MEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Estuf_MEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Saida_MEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_MEM] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consig_MEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Export_MEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Notify_MEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Org_MEM] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst_MEM] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Id_Viagem] [int] NULL,
	[Trf_Net_MEM] [decimal](10, 2) NULL,
	[Qtd_Tot_Vol_MEM] [decimal](4, 0) NULL,
	[Vol_Tot_MEM] [decimal](7, 3) NULL,
	[Peso_Bruto_MEM] [decimal](9, 3) NULL,
	[Tp_Frete_MEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete_MEM] [decimal](10, 2) NULL,
	[Qtd_HAWB_MEM] [char](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nivel_DL] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Armador] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Obs_MEM] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Terminal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[ETA_MEM] [datetime] NULL,
	[ETD_MEM] [datetime] NULL,
 CONSTRAINT [PK__Master_Exp_Mar__31B762FC] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_MEM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Master_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Cd_Co__093F5D4E] FOREIGN KEY([Cd_Consig_MEM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Master_Exp_Mar] CHECK CONSTRAINT [FK__Master_Ex__Cd_Co__093F5D4E]
GO
ALTER TABLE [dbo].[Master_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Cd_Ds__0A338187] FOREIGN KEY([Cd_Dst_MEM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Master_Exp_Mar] CHECK CONSTRAINT [FK__Master_Ex__Cd_Ds__0A338187]
GO
ALTER TABLE [dbo].[Master_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Cd_Ex__0B27A5C0] FOREIGN KEY([Cd_Export_MEM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Master_Exp_Mar] CHECK CONSTRAINT [FK__Master_Ex__Cd_Ex__0B27A5C0]
GO
ALTER TABLE [dbo].[Master_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Cd_No__0C1BC9F9] FOREIGN KEY([Cd_Notify_MEM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Master_Exp_Mar] CHECK CONSTRAINT [FK__Master_Ex__Cd_No__0C1BC9F9]
GO
ALTER TABLE [dbo].[Master_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Cd_Or__0D0FEE32] FOREIGN KEY([Cd_Org_MEM])
REFERENCES [dbo].[Localidade] ([Cd_Local])
GO
ALTER TABLE [dbo].[Master_Exp_Mar] CHECK CONSTRAINT [FK__Master_Ex__Cd_Or__0D0FEE32]
GO
ALTER TABLE [dbo].[Master_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Cd_Tp__0E04126B] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Master_Exp_Mar] CHECK CONSTRAINT [FK__Master_Ex__Cd_Tp__0E04126B]
GO
ALTER TABLE [dbo].[Master_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Master_Ex__Nivel__0EF836A4] FOREIGN KEY([Nivel_DL])
REFERENCES [dbo].[Div_Lucro] ([Nivel_DL])
GO
ALTER TABLE [dbo].[Master_Exp_Mar] CHECK CONSTRAINT [FK__Master_Ex__Nivel__0EF836A4]
GO
ALTER TABLE [dbo].[Master_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK_Master_Exp_Mar_Armador] FOREIGN KEY([Cd_Armador])
REFERENCES [dbo].[Armador] ([Cd_Armador])
GO
ALTER TABLE [dbo].[Master_Exp_Mar] CHECK CONSTRAINT [FK_Master_Exp_Mar_Armador]
GO
ALTER TABLE [dbo].[Master_Exp_Mar]  WITH CHECK ADD  CONSTRAINT [FK_Master_Exp_Mar_Terminal] FOREIGN KEY([Cd_Terminal])
REFERENCES [dbo].[Terminal] ([Cd_Terminal])
GO
ALTER TABLE [dbo].[Master_Exp_Mar] CHECK CONSTRAINT [FK_Master_Exp_Mar_Terminal]
GO
