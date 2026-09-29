SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Encerramento_Report_Temp](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Taxa] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Debito] [decimal](10, 2) NULL,
	[Creditos] [decimal](10, 2) NULL,
	[Data] [datetime] NULL,
	[Cliente] [varchar](50) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
