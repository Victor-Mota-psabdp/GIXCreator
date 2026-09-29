SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ATL_SFDC](
	[Type] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Customer/Vendor] [int] NULL,
	[Job Number] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[BDP Charge Date] [datetime] NULL,
	[BDP Invoice Date] [datetime] NULL,
	[Nota Fiscal Number] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Invoice Number] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[GL_Account] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[AX Charge Code] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[ATL Charge Code] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Charge Description] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Currency] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[C/D Indicator] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Amount] [decimal](10, 2) NULL,
	[Exchange Rate] [decimal](10, 4) NULL,
	[BRL Amount] [decimal](10, 4) NULL,
	[AX SEND IT] [bigint] NULL,
	[Cash Application Dt] [datetime] NULL,
	[Cash Application Reference] [datetime] NULL,
	[Name] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Customer/Supplier Name] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Consol Ref] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Void Dt] [datetime] NULL,
	[CityHall Nota Fiscal] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[SFDX ID] [varchar](30) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
