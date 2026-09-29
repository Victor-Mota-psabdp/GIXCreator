SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Log_Terminal](
	[ID_Log] [bigint] IDENTITY(1,1) NOT NULL,
	[Dt_Ins_Terminal] [datetime] NOT NULL,
	[Cd_Usuario_Terminal] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Oper_Terminal] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Terminal] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Terminal] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Repart] [char](7) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Term_Ofc] [varchar](7) COLLATE Latin1_General_CI_AI NULL,
	[Email] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Email_CC] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
