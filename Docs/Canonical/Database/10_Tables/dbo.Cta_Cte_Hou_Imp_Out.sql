SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cta_Cte_Hou_Imp_Out](
	[Num_Proc_HIO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_HIO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Org_Ins_HIO] [varchar](9) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins_HIO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Org_HIO] [decimal](10, 2) NOT NULL,
	[Dt_Prev_Pgto_HIO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cred_Dev_HIO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desp_Org_HIO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[CPMF_HIO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_RP_HIO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_DN_HIO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CN_HIO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CPA_HIO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_DCN_HIO] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ctb_CC_HIO] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_HIO] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Acesso_NF_HIO] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Pgto_NF_HIO] [decimal](18, 2) NULL,
	[Par_NF_HIO] [float] NULL,
	[Comp_Job_HIO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Contab] [bit] NOT NULL,
	[Vlr_Contab] [decimal](12, 2) NULL,
	[Contab_Ant] [bit] NOT NULL,
	[Vlr_Contab_Ant] [decimal](12, 2) NULL,
	[Contab_Mes_Ano] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[Val_Con_Comp] [decimal](12, 2) NULL,
	[IC] [bigint] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20240603-094659] ON [dbo].[Cta_Cte_Hou_Imp_Out]
(
	[Num_Proc_HIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
