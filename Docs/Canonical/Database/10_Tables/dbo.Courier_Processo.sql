SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Courier_Processo](
	[ID] [bigint] NOT NULL,
	[ID_Item] [int] NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID_Tp_Courier] [int] NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Num_Courier] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Courier] [datetime] NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
 CONSTRAINT [PK_Courier_Processo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[ID_Item] ASC,
	[Num_Proc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
