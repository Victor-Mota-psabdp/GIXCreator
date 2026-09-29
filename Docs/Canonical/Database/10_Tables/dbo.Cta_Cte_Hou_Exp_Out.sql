SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cta_Cte_Hou_Exp_Out](
	[Num_Proc_HEO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_HEO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Org_Ins_HEO] [varchar](9) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins_HEO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Org_HEO] [decimal](10, 2) NOT NULL,
	[Dt_Prev_Pgto_HEO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cred_Dev_HEO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desp_Org_HEO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[CPMF_HEO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_RP_HEO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_DN_HEO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CN_HEO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CPA_HEO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_DCN_HEO] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ctb_CC_HEO] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_HEO] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Acesso_NF_HEO] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Pgto_NF_HEO] [decimal](9, 2) NULL,
	[Par_NF_HEO] [float] NULL,
	[Comp_Job_HEO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Contab] [bit] NOT NULL,
	[Vlr_Contab] [decimal](18, 0) NULL,
	[Contab_Ant] [bit] NOT NULL,
	[Vlr_Contab_Ant] [decimal](18, 0) NULL,
	[Contab_Mes_Ano] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[Val_Con_Comp] [decimal](18, 0) NULL,
	[IC] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Cta_Cte_Hou_Exp_Out] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HEO] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_HEO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
