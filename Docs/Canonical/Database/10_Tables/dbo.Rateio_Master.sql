SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Rateio_Master](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Num_Master] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[R_K] [decimal](18, 5) NULL,
	[R_Q] [decimal](18, 5) NULL,
	[cd_cliente] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[data] [datetime] NULL,
	[dt_upd] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
