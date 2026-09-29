SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Caixa_Hou_Exp_Out](
	[Num_Proc_HEO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_HEO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lcto] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Ref_HEO] [decimal](10, 2) NOT NULL,
	[Dt_Conv_HEO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Par] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Par_Moeda_HEO] [decimal](10, 2) NOT NULL,
	[Vlr_Pgto_Rcto_HEO] [decimal](10, 2) NOT NULL,
	[Dt_Pgto_Rcto_HEO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_ND_HEO] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Bx_HEO] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_HEO] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Num_Rcb_HEO] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ctb_Cx_HEO] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Caixa_Hou_Exp_Out] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HEO] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_HEO] ASC,
	[Num_Lcto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
