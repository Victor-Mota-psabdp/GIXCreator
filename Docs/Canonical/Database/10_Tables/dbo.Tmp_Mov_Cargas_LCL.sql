SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tmp_Mov_Cargas_LCL](
	[StrMachine] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cliente] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Modal] [char](2) COLLATE Latin1_General_CI_AI NOT NULL,
	[Origem] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Destino] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Embarques] [int] NULL,
	[Frete_CC] [decimal](10, 2) NULL,
	[Frete_PP] [decimal](18, 2) NULL,
	[Peso] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
