SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOG_Nota_Cliente](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Dt_NF] [datetime] NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nota_Fiscal] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Cliente] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Tipo_Oper_NF] [varchar](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Justifica] [varchar](500) COLLATE Latin1_General_CI_AI NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
