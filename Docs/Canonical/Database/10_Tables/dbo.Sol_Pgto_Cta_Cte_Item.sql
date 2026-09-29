SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sol_Pgto_Cta_Cte_Item](
	[ID] [bigint] NOT NULL,
	[ID_Item] [int] NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC] [varchar](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Ref] [decimal](18, 2) NOT NULL,
	[Dt_Conv] [datetime] NOT NULL,
	[Cd_Tp_Par] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Par_Moeda] [decimal](18, 4) NOT NULL,
	[Vlr_Pgto_Rcto] [decimal](18, 2) NULL,
	[Num_Proc_Master] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Sol_Pgto_Cta_Cte_Item] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[Num_Proc] ASC,
	[Cd_Tp_Tx] ASC,
	[DC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Sol_Pgto_Cta_Cte_Item]  WITH CHECK ADD  CONSTRAINT [FK_Sol_Pgto_Cta_Cte_Item_Sol_Pgto_Cta_Cte] FOREIGN KEY([ID])
REFERENCES [dbo].[Sol_Pgto_Cta_Cte] ([ID])
GO
ALTER TABLE [dbo].[Sol_Pgto_Cta_Cte_Item] CHECK CONSTRAINT [FK_Sol_Pgto_Cta_Cte_Item_Sol_Pgto_Cta_Cte]
GO
