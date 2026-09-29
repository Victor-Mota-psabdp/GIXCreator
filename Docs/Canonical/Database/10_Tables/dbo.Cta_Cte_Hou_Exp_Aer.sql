SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cta_Cte_Hou_Exp_Aer](
	[Num_Proc_HEA] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_HEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Org_Ins_HEA] [varchar](9) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Org_HEA] [decimal](10, 2) NOT NULL,
	[Dt_Prev_Pgto_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cred_Dev_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desp_Dst_HEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[CPMF_HEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_RP_HEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_DN_HEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CN_HEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CPA_HEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_DCN_HEA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ctb_CC_HEA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_HEA] [int] NULL,
	[Ref_Acesso_NF_HEA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Pgto_NF_HEA] [decimal](18, 2) NULL,
	[Par_NF_HEA] [float] NULL,
	[Comp_HAWB_HEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_JOB_HEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Contab] [bit] NOT NULL,
	[Vlr_Contab] [decimal](12, 2) NULL,
	[Contab_Ant] [bit] NOT NULL,
	[Vlr_Contab_Ant] [decimal](12, 2) NULL,
	[Contab_Mes_Ano] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[Val_Con_Comp] [decimal](12, 2) NULL,
	[IC] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK__Cta_Cte_Hou_Exp___531856C7] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HEA] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_HEA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Aer] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Exp_Aer_Comp_HAWB_HEA]  DEFAULT ('N') FOR [Comp_HAWB_HEA]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Aer] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Exp_Aer_Comp_JOB_HEA]  DEFAULT ('N') FOR [Comp_JOB_HEA]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Aer] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Exp_Aer_Contab_HEA]  DEFAULT (0) FOR [Contab]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Aer] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Exp_Aer_Contab_Ant]  DEFAULT (0) FOR [Contab_Ant]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Cd_Cr__2C538F61] FOREIGN KEY([Cd_Cred_Dev_HEA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Aer] CHECK CONSTRAINT [FK__Cta_Cte_H__Cd_Cr__2C538F61]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Num_P__2F2FFC0C] FOREIGN KEY([Num_Proc_HEA])
REFERENCES [dbo].[House_Exp_Aer] ([Num_Proc_HEA])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Aer] CHECK CONSTRAINT [FK__Cta_Cte_H__Num_P__2F2FFC0C]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Cta_Cte_Hou_Exp_Aer_Tipo_Moeda] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Exp_Aer] CHECK CONSTRAINT [FK_Cta_Cte_Hou_Exp_Aer_Tipo_Moeda]
GO
