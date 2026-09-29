SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Rel_221_PO_MODAL](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Sales Order] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[Customer PO] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[PO Number] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[Shipment Number] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[Courier Number] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[Courier Number - 2nd] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[RE Number] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[DDE Number] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[Invoice] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[Direct Collection] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[Arktec Number] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[NF Number] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[DDE - Date] [datetime] NULL,
	[Order Date] [datetime] NULL,
	[Shipment Creation Date] [datetime] NULL,
	[Invoice Date] [datetime] NULL,
	[Customs Transmission Date] [datetime] NULL,
	[NF Date] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
