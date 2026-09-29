SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AX_Doc_Totais](
	[ID_AX] [int] NULL,
	[Valor] [decimal](10, 2) NULL,
	[Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Paridade] [float] NULL,
	[Valor_Moeda_Local] [decimal](10, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
