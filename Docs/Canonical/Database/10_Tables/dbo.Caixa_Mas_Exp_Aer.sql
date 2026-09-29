SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Caixa_Mas_Exp_Aer](
	[Num_Proc_MEA] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_MEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lcto] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Ref_MEA] [decimal](10, 2) NOT NULL,
	[Dt_Conv_MEA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Par] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Par_Moeda_MEA] [decimal](10, 6) NOT NULL,
	[Vlr_Pgto_Rcto_MEA] [decimal](10, 2) NOT NULL,
	[Dt_Pgto_Rcto_MEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_ND_MEA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_DCN_MEA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Bx_MEA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_MEA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Rcb_MEA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Proc_MEA] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_MEA] ASC,
	[Num_Lcto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Caixa_Mas_Exp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Par])
REFERENCES [dbo].[Tipo_Paridade] ([Cd_Tp_Par])
GO
ALTER TABLE [dbo].[Caixa_Mas_Exp_Aer]  WITH CHECK ADD FOREIGN KEY([Num_Lcto])
REFERENCES [dbo].[Pgto_Rcto] ([Num_Lcto])
GO
ALTER TABLE [dbo].[Caixa_Mas_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Caixa_Mas_Exp_Ae__1EF99443] FOREIGN KEY([Num_Proc_MEA], [Cd_Tp_Tx], [DC_MEA])
REFERENCES [dbo].[Cta_Cte_Mas_Exp_Aer] ([Num_Proc_MEA], [Cd_Tp_Tx], [DC_MEA])
GO
ALTER TABLE [dbo].[Caixa_Mas_Exp_Aer] CHECK CONSTRAINT [FK__Caixa_Mas_Exp_Ae__1EF99443]
GO
