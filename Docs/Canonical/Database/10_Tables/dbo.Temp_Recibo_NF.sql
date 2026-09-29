SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Temp_Recibo_NF](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[DC] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID_Machine] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Oficial] [float] NULL,
	[Tx_Convers] [float] NULL,
	[Vlr_Pago] [float] NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Temp_Recibo_NF] PRIMARY KEY CLUSTERED 
(
	[Num_Proc] ASC,
	[Cd_Tp_Tx] ASC,
	[DC] ASC,
	[ID_Machine] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
