SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Container_LOG_Imp_Mar](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Num_Proc_MIM] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_Cont_IM] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Cont_IM] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
