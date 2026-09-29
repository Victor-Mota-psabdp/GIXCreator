SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Remessa_Mar](
	[Num_Ref_RM] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Oper_RM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Banco] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Agencia] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Cta_Cte] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Qtd_Hou_RM] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Tot_Dol_RM] [decimal](10, 2) NULL,
	[Tx_Dol_RM] [decimal](10, 6) NOT NULL,
	[Cd_Tp_Moeda_C_RM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Tot_Conv_RM] [decimal](10, 2) NULL,
	[Tx_Conv_RM] [decimal](10, 6) NOT NULL,
	[Cd_Tp_Moeda_F_RM] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Tot_Fchto_RM] [decimal](10, 2) NULL,
	[Tx_Fchto_RM] [decimal](10, 6) NOT NULL,
	[Vlr_Tot_RM] [decimal](10, 2) NULL,
	[Dt_RM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Concil_RM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Ref_RM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Remessa_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Remessa_M__Cd_Pe__7814D14C] FOREIGN KEY([Cd_Pes])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Remessa_Mar] CHECK CONSTRAINT [FK__Remessa_M__Cd_Pe__7814D14C]
GO
ALTER TABLE [dbo].[Remessa_Mar]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda_F_RM])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Remessa_Mar]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda_C_RM])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Remessa_Mar]  WITH CHECK ADD FOREIGN KEY([Cd_Banco], [Cd_Agencia], [Num_Cta_Cte])
REFERENCES [dbo].[Cta_Cte] ([Cd_Banco], [Cd_Agencia], [Num_Cta_Cte])
GO
