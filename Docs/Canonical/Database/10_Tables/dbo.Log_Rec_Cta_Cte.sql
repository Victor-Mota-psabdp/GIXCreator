SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Rec_Cta_Cte](
	[Data_Rec] [datetime] NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tp_Oper_Rec] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lcto_Mov] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lcto_Rec] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
