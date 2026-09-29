SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cta_Cte_Mas_Exp_Mar](
	[Num_Proc_MEM] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_MEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Org_Ins_MEM] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins_MEM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Org_MEM] [decimal](10, 2) NOT NULL,
	[Dt_Prev_Pgto_MEM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cred_Dev_MEM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desp_Dst_MEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[CPMF_MEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_RP_MEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_DN_MEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CN_MEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CPA_MEM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_NF_MEM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Acesso_NF_MEM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Pgto_NF_MEM] [decimal](18, 2) NULL,
	[Par_NF_MEM] [float] NULL,
	[Contab] [bit] NOT NULL,
	[Vlr_Contab] [decimal](12, 2) NULL,
	[Contab_Ant] [bit] NOT NULL,
	[Vlr_Contab_ANT] [decimal](12, 2) NULL,
	[Contab_Mes_Ano] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[Val_Con_Comp] [decimal](12, 2) NULL,
	[Num_DCN_MEM] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[IC] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK__Cta_Cte_Mas_Exp___42E1EEFE] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_MEM] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_MEM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Mar] ADD  CONSTRAINT [DF_Cta_Cte_Mas_Exp_Mar_Contab_MEM]  DEFAULT (0) FOR [Contab]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Mar] ADD  CONSTRAINT [DF_Cta_Cte_Mas_Exp_Mar_Contab_Ant]  DEFAULT (0) FOR [Contab_Ant]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_M__Cd_Cr__5E1FF51F] FOREIGN KEY([Cd_Cred_Dev_MEM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_M__Cd_Cr__5E1FF51F]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_M__Cd_Tp__5F141958] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_M__Cd_Tp__5F141958]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_M__Cd_Tp__60083D91] FOREIGN KEY([Cd_Tp_Tx])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_M__Cd_Tp__60083D91]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_M__Num_P__60FC61CA] FOREIGN KEY([Num_Proc_MEM])
REFERENCES [dbo].[Master_Exp_Mar] ([Num_Proc_MEM])
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_M__Num_P__60FC61CA]
GO
