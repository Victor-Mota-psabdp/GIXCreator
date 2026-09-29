SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LLP_Master](
	[Num_Proc_Master] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[ETD_Master] [datetime] NULL,
	[ATD_Master] [datetime] NULL,
	[ETA_Master] [datetime] NULL,
	[ATA_Master] [datetime] NULL,
	[Original_ETA_Master] [datetime] NULL,
	[Cd_Tp_Carga] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Notify] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Liquido] [float] NULL,
	[Peso_Cubado] [float] NULL,
	[Peso_Bruto] [float] NULL,
	[Volume] [float] NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Tipo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Status] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Carrier] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Num_Viagem] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Navio] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ID_Status] [int] NULL,
	[ID_Viagem] [int] NULL,
 CONSTRAINT [PK_LLP_Master] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_Master] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
