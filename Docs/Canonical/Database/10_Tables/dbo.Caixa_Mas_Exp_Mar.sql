SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Caixa_Mas_Exp_Mar](
	[Num_Proc_MEM] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_MEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lcto] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Ref_MEM] [decimal](10, 2) NOT NULL,
	[Dt_Conv_MEM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Par] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Par_Moeda_MEM] [decimal](10, 6) NOT NULL,
	[Vlr_Pgto_Rcto_MEM] [decimal](10, 2) NOT NULL,
	[Dt_Pgto_Rcto_MEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_ND_MEM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_DCN_MEM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Bx_MEM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_MEM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Rcb_MEM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Proc_MEM] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_MEM] ASC,
	[Num_Lcto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Caixa_Mas_Exp_Mar]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Par])
REFERENCES [dbo].[Tipo_Paridade] ([Cd_Tp_Par])
GO
ALTER TABLE [dbo].[Caixa_Mas_Exp_Mar]  WITH CHECK ADD FOREIGN KEY([Num_Lcto])
REFERENCES [dbo].[Pgto_Rcto] ([Num_Lcto])
GO
ALTER TABLE [dbo].[Caixa_Mas_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Caixa_Mas_Exp_Ma__21D600EE] FOREIGN KEY([Num_Proc_MEM], [Cd_Tp_Tx], [DC_MEM])
REFERENCES [dbo].[Cta_Cte_Mas_Exp_Mar] ([Num_Proc_MEM], [Cd_Tp_Tx], [DC_MEM])
GO
ALTER TABLE [dbo].[Caixa_Mas_Exp_Mar] CHECK CONSTRAINT [FK__Caixa_Mas_Exp_Ma__21D600EE]
GO
