SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IBROKER_CAPI_V2](
	[ID] [bigint] NOT NULL,
	[JOB] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Order_Reference] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Order_Date] [datetime] NULL,
	[Code_Origin_Country] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Origin_Country] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[House] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Master] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Act_Carrier_Payment_Date] [datetime] NULL,
	[Gross_Weigth] [decimal](15, 4) NULL,
	[Net_Weigth] [decimal](15, 4) NULL,
	[Code_Modal_RM] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Modal_Description_RM] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ATA_Date] [datetime] NULL,
	[chkRef] [bit] NULL,
	[chkPessoa] [bit] NULL,
	[chkLocal] [bit] NULL,
	[chkTotal] [bit] NULL,
	[chkItem] [bit] NULL,
	[chkDoc] [bit] NULL,
	[Status_Doc] [bit] NULL,
	[Status] [bit] NULL,
 CONSTRAINT [PK_IBROKER_CAP_V2] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
