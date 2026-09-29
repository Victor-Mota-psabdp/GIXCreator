SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cta_Cte_Mas_Imp_Mar](
	[Num_Proc_MIM] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_MIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Org_Ins_MIM] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Org_MIM] [decimal](10, 2) NOT NULL,
	[Dt_Prev_Pgto_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cred_Dev_MIM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Desp_Org_MIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[CPMF_MIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_RP_MIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_DN_MIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CN_MIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Comp_CPA_MIM] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_NF_MIM] [varchar](12) COLLATE Latin1_General_CI_AI NULL,
	[Ref_Acesso_NF_MIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Pgto_NF_MIM] [decimal](18, 2) NULL,
	[Par_NF_MIM] [float] NULL,
	[Contab] [bit] NOT NULL,
	[Vlr_Contab] [decimal](12, 2) NULL,
	[Contab_Ant] [bit] NOT NULL,
	[Vlr_Contab_Ant] [decimal](12, 2) NULL,
	[Contab_Mes_Ano] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[Val_Con_Comp] [decimal](12, 2) NULL,
	[Num_DCN_MIM] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[IC] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK__Cta_Cte_Mas_Imp___44CA3770] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_MIM] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_MIM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Imp_Mar] ADD  CONSTRAINT [DF_Cta_Cte_Mas_Imp_Mar_Contab_MIM]  DEFAULT (0) FOR [Contab]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Imp_Mar] ADD  CONSTRAINT [DF_Cta_Cte_Mas_Imp_Mar_Contab_Ant]  DEFAULT (0) FOR [Contab_Ant]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_M__Cd_Cr__65C116E7] FOREIGN KEY([Cd_Cred_Dev_MIM])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Imp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_M__Cd_Cr__65C116E7]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_M__Cd_Tp__66B53B20] FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Imp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_M__Cd_Tp__66B53B20]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_M__Cd_Tp__67A95F59] FOREIGN KEY([Cd_Tp_Tx])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Imp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_M__Cd_Tp__67A95F59]
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Imp_Mar]  WITH NOCHECK ADD  CONSTRAINT [FK__Cta_Cte_M__Num_P__53E25DCE] FOREIGN KEY([Num_Proc_MIM])
REFERENCES [dbo].[Master_Imp_Mar] ([Num_Proc_MIM])
GO
ALTER TABLE [dbo].[Cta_Cte_Mas_Imp_Mar] CHECK CONSTRAINT [FK__Cta_Cte_M__Num_P__53E25DCE]
GO
