SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Cta_Cte_HOU_BDP_OUT](
	[Num_Proc_HBO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_HBO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Org_Ins_HBO] [varchar](9) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins_HBO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Org_HBO] [decimal](10, 2) NOT NULL,
	[Dt_Prev_Pgto_HBO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cred_Dev_HBO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desp_Org_HBO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[CPMF_HBO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_RP_HBO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_DN_HBO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CN_HBO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CPA_HBO] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_DCN_HBO] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ctb_CC_HBO] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_HBO] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Acesso_NF_HBO] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Pgto_NF_HBO] [decimal](18, 2) NULL,
	[Par_NF_HBO] [float] NULL,
	[Comp_Job_HBO] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Contab] [bit] NULL,
	[Vlr_Contab] [decimal](12, 2) NULL,
	[Contab_Ant] [bit] NULL,
	[Vlr_Contab_Ant] [decimal](12, 2) NULL,
	[Contab_Mes_Ano] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[Val_Con_Comp] [decimal](12, 2) NULL,
	[IC] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK__Cta_Cte_HOU_BDP_OUT] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HBO] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_HBO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Cta_Cte_HOU_BDP_OUT] ADD  CONSTRAINT [DF_Cta_Cte_HOU_BDP_OUT_Comp_JOB_HEA]  DEFAULT ('N') FOR [Comp_Job_HBO]
GO
ALTER TABLE [dbo].[Cta_Cte_HOU_BDP_OUT] ADD  CONSTRAINT [DF_Cta_Cte_HOU_BDP_OUT_Contab]  DEFAULT ((0)) FOR [Contab]
GO
ALTER TABLE [dbo].[Cta_Cte_HOU_BDP_OUT] ADD  CONSTRAINT [DF_Cta_Cte_HOU_BDP_OUT_Contab_Ant]  DEFAULT ((0)) FOR [Contab_Ant]
GO
ALTER TABLE [dbo].[Cta_Cte_HOU_BDP_OUT]  WITH CHECK ADD  CONSTRAINT [FK_Cta_Cte_HOU_BDP_OUT_House_BDP_OUT] FOREIGN KEY([Num_Proc_HBO])
REFERENCES [dbo].[House_BDP_OUT] ([Num_Proc_HBO])
GO
ALTER TABLE [dbo].[Cta_Cte_HOU_BDP_OUT] CHECK CONSTRAINT [FK_Cta_Cte_HOU_BDP_OUT_House_BDP_OUT]
GO
ALTER TABLE [dbo].[Cta_Cte_HOU_BDP_OUT]  WITH CHECK ADD  CONSTRAINT [FK_Cta_Cte_HOU_BDP_OUT_Pessoa] FOREIGN KEY([Cd_Cred_Dev_HBO])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Cta_Cte_HOU_BDP_OUT] CHECK CONSTRAINT [FK_Cta_Cte_HOU_BDP_OUT_Pessoa]
GO
ALTER TABLE [dbo].[Cta_Cte_HOU_BDP_OUT]  WITH CHECK ADD  CONSTRAINT [FK_Cta_Cte_HOU_BDP_OUT_Tipo_Moeda] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Cta_Cte_HOU_BDP_OUT] CHECK CONSTRAINT [FK_Cta_Cte_HOU_BDP_OUT_Tipo_Moeda]
GO
ALTER TABLE [dbo].[Cta_Cte_HOU_BDP_OUT]  WITH CHECK ADD  CONSTRAINT [FK_Cta_Cte_HOU_BDP_OUT_Tipo_Taxa] FOREIGN KEY([Cd_Tp_Tx])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Cta_Cte_HOU_BDP_OUT] CHECK CONSTRAINT [FK_Cta_Cte_HOU_BDP_OUT_Tipo_Taxa]
GO
