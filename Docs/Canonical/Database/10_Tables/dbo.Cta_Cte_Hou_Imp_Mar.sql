SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cta_Cte_Hou_Imp_Mar](
	[Num_Proc_HIM] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_HIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Org_Ins_HIM] [varchar](9) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Org_HIM] [decimal](10, 2) NOT NULL,
	[Dt_Prev_Pgto_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cred_Dev_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desp_Org_HIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[CPMF_HIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_RP_HIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_DN_HIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CN_HIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CPA_HIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_DCN_HIM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ctb_CC_HIM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_HIM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Acesso_NF_HIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Pgto_NF_HIM] [decimal](18, 2) NULL,
	[Par_NF_HIM] [float] NULL,
	[Comp_Job_HIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Contab] [bit] NOT NULL,
	[Vlr_Contab] [decimal](12, 2) NULL,
	[Contab_Ant] [bit] NOT NULL,
	[Vlr_Contab_Ant] [decimal](12, 2) NULL,
	[Contab_Mes_Ano] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[Val_Con_Comp] [decimal](12, 2) NULL,
	[IC] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK__Cta_Cte_Hou_Imp___55F4C372] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HIM] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_HIM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200515-160336] ON [dbo].[Cta_Cte_Hou_Imp_Mar]
(
	[IC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Mar] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Imp_Mar_Comp_Job_HIM]  DEFAULT ('N') FOR [Comp_Job_HIM]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Mar] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Imp_Mar_Contab_HIM]  DEFAULT (0) FOR [Contab]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Mar] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Imp_Mar_Conta_Ant]  DEFAULT (0) FOR [Contab_Ant]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Cd_Cr__37C5420D] FOREIGN KEY([Cd_Cred_Dev_HIM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_H__Cd_Cr__37C5420D]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Cd_Tp__38B96646] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_H__Cd_Tp__38B96646]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Cd_Tp__39AD8A7F] FOREIGN KEY([Cd_Tp_Tx])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_H__Cd_Tp__39AD8A7F]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Num_P__3AA1AEB8] FOREIGN KEY([Num_Proc_HIM])
REFERENCES [dbo].[House_Imp_Mar] ([Num_Proc_HIM])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_H__Num_P__3AA1AEB8]
GO
