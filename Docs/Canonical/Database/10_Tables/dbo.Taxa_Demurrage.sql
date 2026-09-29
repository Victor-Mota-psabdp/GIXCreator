SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Taxa_Demurrage](
	[cd_tp_cont] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[periodo] [int] NOT NULL,
	[taxa] [decimal](12, 2) NOT NULL,
	[dias] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
