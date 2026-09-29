SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Caixa_Hou_Imp_Aer](
	[Num_Proc_HIA] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_HIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lcto] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Ref_HIA] [decimal](10, 2) NOT NULL,
	[Dt_Conv_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Par] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Par_Moeda_HIA] [decimal](10, 6) NOT NULL,
	[Vlr_Pgto_Rcto_HIA] [decimal](10, 2) NOT NULL,
	[Dt_Pgto_Rcto_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_ND_HIA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Bx_HIA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_HIA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Rcb_HIA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ctb_Cx_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HIA] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_HIA] ASC,
	[Num_Lcto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Caixa_Hou_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Par])
REFERENCES [dbo].[Tipo_Paridade] ([Cd_Tp_Par])
GO
ALTER TABLE [dbo].[Caixa_Hou_Imp_Aer]  WITH CHECK ADD FOREIGN KEY([Num_Lcto])
REFERENCES [dbo].[Pgto_Rcto] ([Num_Lcto])
GO
ALTER TABLE [dbo].[Caixa_Hou_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Caixa_Hou_Imp_Ae__4DB4832C] FOREIGN KEY([Num_Proc_HIA], [Cd_Tp_Tx], [DC_HIA])
REFERENCES [dbo].[Cta_Cte_Hou_Imp_Aer] ([Num_Proc_HIA], [Cd_Tp_Tx], [DC_HIA])
GO
ALTER TABLE [dbo].[Caixa_Hou_Imp_Aer] CHECK CONSTRAINT [FK__Caixa_Hou_Imp_Ae__4DB4832C]
GO
