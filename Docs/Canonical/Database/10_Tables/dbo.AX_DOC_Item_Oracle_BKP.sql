SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AX_DOC_Item_Oracle_BKP](
	[ID_AX] [bigint] NULL,
	[ID_Item] [int] NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_TX] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[DC] [char](3) COLLATE Latin1_General_CI_AI NULL,
	[Valor] [decimal](18, 2) NULL,
	[Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Numero_House] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CSREmail] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CSRName] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Paridade] [float] NULL,
	[AccountType] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[MasterBOLNbr] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[MasterBookingNbr] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[TaxGroup] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Notes] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc_Master] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Account_Number] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Invoicing] [bit] NULL,
	[Valor_Impostos] [decimal](18, 2) NULL,
	[Dimensao_1] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dimensao_2] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dimensao_3] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dimensao_4] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dimensao_5] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dimensao_6] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dimensao_7] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Valor_Em_Moeda_Local] [decimal](10, 2) NULL,
	[citCityHallServiceCode] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[citCityHallServiceDesc] [varchar](255) COLLATE Latin1_General_CI_AI NULL,
	[CitTransDateNF] [datetime] NULL,
	[07Invoice] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[DocumentNum] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[cd_tp_Tx_ATL] [varchar](3) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
