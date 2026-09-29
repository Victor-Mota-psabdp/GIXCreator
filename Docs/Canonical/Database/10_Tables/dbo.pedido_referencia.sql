SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[pedido_referencia](
	[ID_Ref] [int] NULL,
	[ID_Descr] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Codigo] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Descr_Cliente] [varchar](50) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
