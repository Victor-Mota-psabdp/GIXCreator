SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Account](
	[id_Account] [int] IDENTITY(1,1) NOT NULL,
	[Cd_Bank] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Agency] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Account] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Billing_Code] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Assignor] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[OBS] [varchar](250) COLLATE Latin1_General_CI_AI NULL,
	[Account_Enabled] [bit] NOT NULL,
	[Generate_Remessa_Enabled] [bit] NOT NULL,
	[Generate_Boleto_Enabled] [bit] NOT NULL,
	[Cd_User] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [datetime] NULL,
	[dt_alt] [datetime] NULL,
 CONSTRAINT [PK_idaccont] PRIMARY KEY CLUSTERED 
(
	[id_Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
