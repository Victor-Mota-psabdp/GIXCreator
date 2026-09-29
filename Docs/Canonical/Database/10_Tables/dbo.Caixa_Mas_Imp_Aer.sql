SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Caixa_Mas_Imp_Aer](
	[Num_Proc_MIA] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_MIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lcto] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Ref_MIA] [decimal](10, 2) NOT NULL,
	[Dt_Conv_MIA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Par] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Par_Moeda_MIA] [decimal](10, 6) NOT NULL,
	[Vlr_Pgto_Rcto_MIA] [decimal](10, 2) NOT NULL,
	[Dt_Pgto_Rcto_MIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_ND_MIA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_DCN_MIA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Bx_MIA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_MIA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Rcb_MIA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Proc_MIA] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_MIA] ASC,
	[Num_Lcto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Caixa_Mas_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Par])
REFERENCES [dbo].[Tipo_Paridade] ([Cd_Tp_Par])
GO
ALTER TABLE [dbo].[Caixa_Mas_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Num_Lcto])
REFERENCES [dbo].[Pgto_Rcto] ([Num_Lcto])
GO
ALTER TABLE [dbo].[Caixa_Mas_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Caixa_Mas_Imp_Ae__24B26D99] FOREIGN KEY([Num_Proc_MIA], [Cd_Tp_Tx], [DC_MIA])
REFERENCES [dbo].[Cta_Cte_Mas_Imp_Aer] ([Num_Proc_MIA], [Cd_Tp_Tx], [DC_MIA])
GO
ALTER TABLE [dbo].[Caixa_Mas_Imp_Aer] CHECK CONSTRAINT [FK__Caixa_Mas_Imp_Ae__24B26D99]
GO
