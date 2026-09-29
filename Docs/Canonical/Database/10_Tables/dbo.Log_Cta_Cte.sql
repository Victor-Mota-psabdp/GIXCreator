SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Cta_Cte](
	[Data_CC] [datetime] NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Oper_CC] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Proc_CC] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC_CC] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Org_Ins] [varchar](9) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Org] [decimal](10, 2) NULL,
	[Dt_Prev_Pgto] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Cred_Dev] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Desp_Org_Dst] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[CPMF] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Comp_RP] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Comp_DN] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Comp_CN] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Comp_CPA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Contab] [bit] NOT NULL,
	[Vlr_Contab] [decimal](12, 2) NULL,
	[Contab_Ant] [bit] NOT NULL,
	[Cointab_Mes_Ano] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[logctaid] [bigint] IDENTITY(1,1) NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[Data_CC] ASC,
	[Cd_Usuario] ASC,
	[Tp_Oper_CC] ASC,
	[Num_Proc_CC] ASC,
	[Cd_Tp_Tx] ASC,
	[DC_CC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200515-163103] ON [dbo].[Log_Cta_Cte]
(
	[logctaid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Log_Cta_Cte] ADD  CONSTRAINT [DF_Log_Cta_Cte_Contab]  DEFAULT (0) FOR [Contab]
GO
ALTER TABLE [dbo].[Log_Cta_Cte] ADD  CONSTRAINT [DF_Log_Cta_Cte_Contab_Ant]  DEFAULT (0) FOR [Contab_Ant]
GO
ALTER TABLE [dbo].[Log_Cta_Cte]  WITH NOCHECK ADD  CONSTRAINT [FK__Log_Cta_C__Cd_Cr__57A801BA] FOREIGN KEY([Cd_Cred_Dev])
REFERENCES [dbo].[Pessoa] ([Cd_Pes])
GO
ALTER TABLE [dbo].[Log_Cta_Cte] CHECK CONSTRAINT [FK__Log_Cta_C__Cd_Cr__57A801BA]
GO
ALTER TABLE [dbo].[Log_Cta_Cte]  WITH CHECK ADD FOREIGN KEY([Cd_Tp_Moeda])
REFERENCES [dbo].[Tipo_Moeda] ([Cd_Tp_Moeda])
GO
ALTER TABLE [dbo].[Log_Cta_Cte]  WITH CHECK ADD  CONSTRAINT [FK__Log_Cta_C__Cd_Tp__59904A2C] FOREIGN KEY([Cd_Tp_Tx])
REFERENCES [dbo].[Tipo_Taxa] ([Cd_Tp_Tx])
GO
ALTER TABLE [dbo].[Log_Cta_Cte] CHECK CONSTRAINT [FK__Log_Cta_C__Cd_Tp__59904A2C]
GO
ALTER TABLE [dbo].[Log_Cta_Cte]  WITH CHECK ADD FOREIGN KEY([Cd_Usuario])
REFERENCES [dbo].[Usuario] ([Cd_Usuario])
GO
