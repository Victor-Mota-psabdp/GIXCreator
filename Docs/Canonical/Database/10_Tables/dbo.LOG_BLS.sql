SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOG_BLS](
	[Status_Oper] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Data_Ins] [datetime] NULL,
	[JOB] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Tipo] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[DataInicial] [datetime] NULL,
	[DataFinal] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
