SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOG_AX_DOC_XML](
	[ID_AX] [bigint] NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_TX_aTL] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC] [varchar](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cancel] [bit] NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
