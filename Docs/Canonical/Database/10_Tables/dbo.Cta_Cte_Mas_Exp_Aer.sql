SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cta_Cte_Mas_Exp_Aer](
	[Num_Proc_MEA] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_MEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Org_Ins_MEA] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins_MEA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Org_MEA] [decimal](10, 2) NOT NULL,
	[Dt_Prev_Pgto_MEA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cred_Dev_MEA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desp_Dst_MEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[CPMF_MEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_RP_MEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_DN_MEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CN_MEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CPA_MEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_NF_MEA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Pgto_NF_MEA] [decimal](18, 2) NULL,
	[Par_NF_MEA] [float] NULL,
	[Ref_Acesso_NF_MEA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Comp_MBL_MEA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Contab] [bit] NOT NULL,
	[Vlr_Contab] [decimal](12, 2) NULL,
	[Contab_Ant] [bit] NOT NULL,
	[Vlr_Contab_Ant] [decimal](12, 2) NULL,
	[Contab_Mes_Ano] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[Val_Con_Comp] [decimal](12, 2) NULL,
	[Num_DCN_MEA] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[IC] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK__Cta_Cte_Mas_Exp___41EDCAC5] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_MEA] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_MEA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Aer] ADD  CONSTRAINT [DF_Cta_Cte_Mas_Exp_Aer_Comp_MBL_MEA]  DEFAULT ('N') FOR [Comp_MBL_MEA]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Aer] ADD  CONSTRAINT [DF_Cta_Cte_Mas_Exp_Aer_Contab_MEA]  DEFAULT (0) FOR [Contab]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Aer] ADD  CONSTRAINT [DF_Cta_Cte_Mas_Exp_Aer_Contab_Ant]  DEFAULT (0) FOR [Contab_Ant]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_M__Cd_Cr__5A4F643B] FOREIGN KEY([Cd_Cred_Dev_MEA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Aer] CHECK CONSTRAINT [FK__Cta_Cte_M__Cd_Cr__5A4F643B]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Cta_Cte_Mas_Exp_Aer_Master_Exp_Aer] FOREIGN KEY([Num_Proc_MEA])
REFERENCES [dbo].[Master_Exp_Aer] ([Num_Proc_MEA])
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Aer] CHECK CONSTRAINT [FK_Cta_Cte_Mas_Exp_Aer_Master_Exp_Aer]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Aer]  WITH CHECK ADD  CONSTRAINT [FK_Cta_Cte_Mas_Exp_Aer_Tipo_Moeda] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Aer] CHECK CONSTRAINT [FK_Cta_Cte_Mas_Exp_Aer_Tipo_Moeda]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK_Cta_Cte_Mas_Exp_Aer_Tipo_Taxa] FOREIGN KEY([Cd_Tp_Tx])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Exp_Aer] CHECK CONSTRAINT [FK_Cta_Cte_Mas_Exp_Aer_Tipo_Taxa]
GO
