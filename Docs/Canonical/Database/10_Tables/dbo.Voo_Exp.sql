SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Voo_Exp](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item] [int] NOT NULL,
	[Cd_Org] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[ETD] [datetime] NULL,
	[ETA] [datetime] NULL,
	[ATA] [datetime] NULL,
	[ATD] [datetime] NULL,
	[Cd_CiaAerea] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Voo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Voo_Exp] ADD  DEFAULT (getdate()) FOR [dt_ins]
GO
