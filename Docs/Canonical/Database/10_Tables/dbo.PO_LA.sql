SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PO_LA](
	[Num_LA] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID_PO_LA] [int] NOT NULL,
	[Numero_PO] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Data_PO] [datetime] NULL,
	[ID_DC] [int] NULL,
	[Nome_Arquivo] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Envio] [datetime] NULL,
	[Dt_Ins] [datetime] NULL,
	[Cd_Usuario] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Valor] [float] NULL,
	[Gravado] [float] NULL,
	[IVA] [float] NULL,
	[Paridade] [float] NULL,
	[Valor_USD] [float] NULL,
	[Gravado_USD] [float] NULL,
	[IVA_USD] [float] NULL,
	[CAI] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[CAI_Vcto] [datetime] NULL,
	[Ing_Brt] [float] NULL,
	[Ing_Brt_USD] [float] NULL,
	[Ret] [float] NULL,
	[Ret_USD] [float] NULL,
 CONSTRAINT [PK_PO_LA] PRIMARY KEY CLUSTERED 
(
	[Num_LA] ASC,
	[ID_PO_LA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
