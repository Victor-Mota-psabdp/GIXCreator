SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Caixa_Hou_Imp_Out](
	[Num_Proc_HIO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_HIO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lcto] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Ref_HIO] [decimal](10, 2) NOT NULL,
	[Dt_Conv_HIO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Par] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Par_Moeda_HIO] [decimal](10, 6) NOT NULL,
	[Vlr_Pgto_Rcto_HIO] [decimal](10, 2) NOT NULL,
	[Dt_Pgto_Rcto_HIO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_ND_HIO] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Bx_HIO] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_HIO] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Rcb_HIO] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ctb_Cx_HIO] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Caixa_Hou_Imp_Out] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HIO] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_HIO] ASC,
	[Num_Lcto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Caixa_Hou_Imp_Out]  WITH CHECK ADD  CONSTRAINT [FK_Caixa_Hou_Imp_Out_Pgto_Rcto] FOREIGN KEY([Num_Lcto])
REFERENCES [dbo].[Pgto_Rcto] ([Num_Lcto])
GO
ALTER TABLE [dbo].[Caixa_Hou_Imp_Out] CHECK CONSTRAINT [FK_Caixa_Hou_Imp_Out_Pgto_Rcto]
GO
