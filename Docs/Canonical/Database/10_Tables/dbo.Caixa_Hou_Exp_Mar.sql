SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Caixa_Hou_Exp_Mar](
	[Num_Proc_HEM] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_HEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lcto] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Ref_HEM] [decimal](10, 2) NOT NULL,
	[Dt_Conv_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Par] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Par_Moeda_HEM] [decimal](10, 6) NOT NULL,
	[Vlr_Pgto_Rcto_HEM] [decimal](10, 2) NOT NULL,
	[Dt_Pgto_Rcto_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_ND_HEM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Bx_HEM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_HEM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Rcb_HEM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ctb_Cx_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HEM] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_HEM] ASC,
	[Num_Lcto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Caixa_Hou_Exp_Mar]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Par])
REFERENCES [dbo].[Tipo_Paridade] ([Cd_Tp_Par])
GO
ALTER TABLE [dbo].[Caixa_Hou_Exp_Mar]  WITH CHECK ADD FOREIGN KEY([Num_Lcto])
REFERENCES [dbo].[Pgto_Rcto] ([Num_Lcto])
GO
ALTER TABLE [dbo].[Caixa_Hou_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Caixa_Hou_Exp_Ma__4AD81681] FOREIGN KEY([Num_Proc_HEM], [Cd_Tp_Tx], [DC_HEM])
REFERENCES [dbo].[Cta_Cte_Hou_Exp_Mar] ([Num_Proc_HEM], [Cd_Tp_Tx], [DC_HEM])
GO
ALTER TABLE [dbo].[Caixa_Hou_Exp_Mar] CHECK CONSTRAINT [FK__Caixa_Hou_Exp_Ma__4AD81681]
GO
