SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cta_Cte_Hou_Exp_Mar](
	[Num_Proc_HEM] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_HEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Org_Ins_HEM] [varchar](9) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Org_HEM] [decimal](10, 2) NOT NULL,
	[Dt_Prev_Pgto_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cred_Dev_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desp_Dst_HEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[CPMF_HEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_RP_HEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_DN_HEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CN_HEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CPA_HEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_DCN_HEM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ctb_CC_HEM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_HEM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Acesso_NF_HEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Pgto_NF_HEM] [decimal](18, 2) NULL,
	[Par_NF_HEM] [float] NULL,
	[Comp_Job_HEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Contab] [bit] NOT NULL,
	[Vlr_Contab] [decimal](12, 2) NULL,
	[Contab_Ant] [bit] NOT NULL,
	[Vlr_Contab_Ant] [decimal](12, 2) NULL,
	[Contab_Mes_Ano] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[Val_Con_Comp] [decimal](12, 2) NULL,
	[IC] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK__Cta_Cte_Hou_Exp___540C7B00] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HEM] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_HEM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Mar] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Exp_Mar_Comp_Job_HEM]  DEFAULT ('N') FOR [Comp_Job_HEM]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Mar] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Exp_Mar_Contab_HEM]  DEFAULT (0) FOR [Contab]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Mar] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Exp_Mar_Contab_Ant]  DEFAULT (0) FOR [Contab_Ant]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Cd_Cr__30242045] FOREIGN KEY([Cd_Cred_Dev_HEM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_H__Cd_Cr__30242045]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Cd_Tp__3118447E] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_H__Cd_Tp__3118447E]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Cd_Tp__320C68B7] FOREIGN KEY([Cd_Tp_Tx])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_H__Cd_Tp__320C68B7]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Num_P__33008CF0] FOREIGN KEY([Num_Proc_HEM])
REFERENCES [dbo].[House_Exp_Mar] ([Num_Proc_HEM])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_H__Num_P__33008CF0]
GO
