SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cta_Cte_Hou_Imp_Aer](
	[Num_Proc_HIA] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_HIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Org_Ins_HIA] [varchar](9) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Org_HIA] [decimal](10, 2) NOT NULL,
	[Dt_Prev_Pgto_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cred_Dev_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desp_Org_HIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[CPMF_HIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_RP_HIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_DN_HIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CN_HIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CPA_HIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_DCN_HIA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ctb_CC_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_NF_HIA] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Acesso_NF_HIA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Pgto_NF_HIA] [decimal](18, 2) NULL,
	[Par_NF_HIA] [float] NULL,
	[Comp_Job_HIA] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Contab] [bit] NOT NULL,
	[Vlr_Contab] [decimal](12, 2) NULL,
	[Contab_Ant] [bit] NOT NULL,
	[Vlr_Contab_Ant] [decimal](12, 2) NULL,
	[Contab_Mes_Ano] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[Val_Con_Comp] [decimal](12, 2) NULL,
	[IC] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK__Cta_Cte_Hou_Imp___55009F39] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HIA] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_HIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Aer] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Imp_Aer_Comp_Job_HIA]  DEFAULT ('N') FOR [Comp_Job_HIA]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Aer] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Imp_Aer_Contab_HIA]  DEFAULT (0) FOR [Contab]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Aer] ADD  CONSTRAINT [DF_Cta_Cte_Hou_Imp_Aer_Contab_Ant]  DEFAULT (0) FOR [Contab_Ant]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Cd_Cr__33F4B129] FOREIGN KEY([Cd_Cred_Dev_HIA])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Aer] CHECK CONSTRAINT [FK__Cta_Cte_H__Cd_Cr__33F4B129]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Cd_Tp__34E8D562] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Aer] CHECK CONSTRAINT [FK__Cta_Cte_H__Cd_Tp__34E8D562]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Cd_Tp__35DCF99B] FOREIGN KEY([Cd_Tp_Tx])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Aer] CHECK CONSTRAINT [FK__Cta_Cte_H__Cd_Tp__35DCF99B]
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Aer]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_H__Num_P__36D11DD4] FOREIGN KEY([Num_Proc_HIA])
REFERENCES [dbo].[House_Imp_Aer] ([Num_Proc_HIA])
GO
ALTER TABLE [dbo].[Cta_Cte_Hou_Imp_Aer] CHECK CONSTRAINT [FK__Cta_Cte_H__Num_P__36D11DD4]
GO
