SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IBROKER_CAP2](
	[ID_ITDI] [bigint] NOT NULL,
	[01] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[02] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[03] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[04] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[05] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[06] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[07] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[08] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[09] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[10] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[11] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[12] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[13] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[14] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[15] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[16] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[17] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[18] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[19] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[20] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[21] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[22] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[23] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[24] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[25] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[26] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[27] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[28] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[29] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[30] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[31] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[32] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[33] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[34] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[35] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_IBROKER_CAP2] PRIMARY KEY CLUSTERED 
(
	[ID_ITDI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
