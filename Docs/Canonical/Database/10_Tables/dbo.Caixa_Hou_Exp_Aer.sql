SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Caixa_Hou_Exp_Aer](
	[Num_Proc_HEA] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_HEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lcto] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Ref_HEA] [decimal](10, 2) NOT NULL,
	[Dt_Conv_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Par] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Par_Moeda_HEA] [decimal](10, 6) NOT NULL,
	[Vlr_Pgto_Rcto_HEA] [decimal](10, 2) NOT NULL,
	[Dt_Pgto_Rcto_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_ND_HEA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Bx_HEA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_HEA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Rcb_HEA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ctb_Cx_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HEA] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_HEA] ASC,
	[Num_Lcto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
