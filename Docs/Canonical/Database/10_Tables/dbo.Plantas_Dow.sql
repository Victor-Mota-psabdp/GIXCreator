SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Plantas_Dow](
	[ID] [bigint] NOT NULL,
	[Business_Place] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Business_Place_Description] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Plant] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Name_1] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Tax_Number_1] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[State_Tax_Number] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Valuation_Area] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Customer_no_plant] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Vendor_number_plant] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Co_Code] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Name_2] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[House_number_and_street] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Postal_Code] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[City] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Purch_Organization] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Sales_organization] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Country_Key] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Region] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Address] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Planning_plant] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Tax_Jurisdiction] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Plantas_Dow] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
