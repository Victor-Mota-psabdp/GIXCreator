SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Dow_Syncro_Temp](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Invoice] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[CCD] [datetime] NULL,
	[SalesOrder] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[NFNumber] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[NFDate] [datetime] NULL,
	[EntryNumber] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[DDENumber] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[DDEDate] [datetime] NULL,
	[AverbacaoExp] [datetime] NULL,
	[DSEDate] [datetime] NULL,
	[DSENumber] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[House] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Master] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[ProcessStatus] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ETDDate] [datetime] NULL,
	[ATDDate] [datetime] NULL,
	[Revisar] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Comments] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Responsavel] [varchar](50) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
