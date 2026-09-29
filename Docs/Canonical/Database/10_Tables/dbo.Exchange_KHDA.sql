SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Exchange_KHDA](
	[ExcId] [int] IDENTITY(1,1) NOT NULL,
	[ExcFile] [varchar](34) COLLATE Latin1_General_CI_AI NULL,
	[ExcProcesso] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ExcDataAlt] [datetime] NOT NULL,
	[ExcStatus] [bit] NOT NULL,
	[ExcDtEnvio] [datetime] NULL,
	[ExcDtRetorno] [datetime] NULL,
	[excReportManager] [datetime] NULL,
	[excReportManager2] [datetime] NULL,
	[dt_envio_JMD_AX] [datetime] NULL,
 CONSTRAINT [PK_Exchange_kHDA] PRIMARY KEY CLUSTERED 
(
	[ExcId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
