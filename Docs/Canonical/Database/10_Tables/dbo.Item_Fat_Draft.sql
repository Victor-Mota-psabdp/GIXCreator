SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Item_Fat_Draft](
	[FatCod] [varchar](19) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Vlr_Org] [decimal](12, 2) NOT NULL,
	[Vlr_RS] [decimal](12, 2) NULL,
	[Paridade] [float] NULL,
	[Vlr_Cont_Item] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
