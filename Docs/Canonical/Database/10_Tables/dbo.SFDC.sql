SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SFDC](
	[ne] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[SFDC_ID] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[AX_SENT_ID] [int] NULL,
	[AX_Customer_VEndor] [int] NULL,
	[PT] [int] NULL,
	[Account_Name] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](26) COLLATE Latin1_General_CI_AI NULL,
	[Invoice] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[ATL_NF] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Charge_Code] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Charge_Descr] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[TransType] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[D_C] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Currency] [char](3) COLLATE Latin1_General_CI_AI NULL,
	[Amount] [decimal](10, 2) NULL,
	[BRL_Amount] [decimal](10, 2) NULL,
	[BDPCharge_Dt] [datetime] NULL,
	[Dt_Ins] [datetime] NULL,
 CONSTRAINT [PK_SFDC] PRIMARY KEY CLUSTERED 
(
	[SFDC_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
