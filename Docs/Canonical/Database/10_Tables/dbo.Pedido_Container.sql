SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pedido_Container](
	[Cd_Pedido] [int] NOT NULL,
	[Num_Cont] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Lacre] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Bruto_VGM] [float] NULL,
	[UOM_VGM] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Responsavel_VGM] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Envio_VGM] [datetime] NULL,
	[Metodo_VGM] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[DT_Ins] [datetime] NULL,
 CONSTRAINT [PK_Pedido_Container] PRIMARY KEY CLUSTERED 
(
	[Cd_Pedido] ASC,
	[Num_Cont] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
