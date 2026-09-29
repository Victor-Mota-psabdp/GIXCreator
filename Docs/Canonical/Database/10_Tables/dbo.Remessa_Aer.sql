SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Remessa_Aer](
	[Num_Ref_RA] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Oper_RA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Banco] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cod_Praca_RA] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Agencia] [varchar](5) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Cta_Cte] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Qtd_Hou_RA] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Tot_Dol_RA] [decimal](10, 2) NULL,
	[Tx_Dol_RA] [decimal](10, 6) NOT NULL,
	[Cd_Tp_Moeda_C_RA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Tot_Conv_RA] [decimal](10, 2) NULL,
	[Tx_Conv_RA] [decimal](10, 6) NOT NULL,
	[Cd_Tp_Moeda_F_RA] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Tot_Fchto_RA] [decimal](10, 2) NULL,
	[Tx_Fchto_RA] [decimal](10, 6) NOT NULL,
	[Vlr_Tot_RA] [decimal](10, 2) NULL,
	[Dt_RA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Concil_RA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Ref_RA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Remessa_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Remessa_A__Cd_Pe__74444068] FOREIGN KEY([Cd_Pes])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Remessa_Aer] CHECK CONSTRAINT [FK__Remessa_A__Cd_Pe__74444068]
GO
ALTER TABLE [dbo].[Remessa_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda_F_RA])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Remessa_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda_C_RA])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Remessa_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Banco], [Cd_Agencia], [Num_Cta_Cte])
REFERENCES [dbo].[Cta_Cte] ([Cd_Banco], [Cd_Agencia], [Num_Cta_Cte])
GO
