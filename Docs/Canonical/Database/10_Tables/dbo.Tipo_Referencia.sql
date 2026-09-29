SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Referencia](
	[ID_Ref] [int] NOT NULL,
	[Referencia_Descr] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[BDPSmart_Descr] [varchar](30) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
