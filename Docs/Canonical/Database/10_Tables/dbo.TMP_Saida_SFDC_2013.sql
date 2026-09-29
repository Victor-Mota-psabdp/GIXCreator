SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TMP_Saida_SFDC_2013](
	[Type] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[CustomerVendor AX ID] [bigint] NULL,
	[Job Number] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[BDP Charge Dt] [datetime] NULL,
	[BDP Invoice Dt] [datetime] NULL,
	[Nota Fiscal Number] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[Invoice Number] [varchar](145) COLLATE Latin1_General_CI_AI NULL,
	[GL Account] [varchar](35) COLLATE Latin1_General_CI_AI NULL,
	[AX Charge Code] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ATL Charge Code] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Charge Description] [varchar](160) COLLATE Latin1_General_CI_AI NULL,
	[Currency Code] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Debit/Credit] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Amount] [decimal](18, 2) NULL,
	[Exchange Rate] [decimal](18, 6) NULL,
	[BRL Amount] [decimal](18, 2) NULL,
	[AX ID SENT] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Cash Application Dt] [datetime] NULL,
	[Cash Application Reference] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Name] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[Customer/Vendor Name] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[Consol] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Void Dt] [datetime] NULL,
	[NF Eletronic #] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[IC_Number] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
