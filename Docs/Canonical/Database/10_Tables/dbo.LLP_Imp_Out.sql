SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LLP_Imp_Out](
	[Num_Proc_Lio] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ETA_Lio] [datetime] NULL,
	[ETD_Lio] [datetime] NULL,
	[ATD_Lio] [datetime] NULL,
	[ATA_Lio] [datetime] NULL,
	[Cd_Planta_Lio] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_DstFinal_Lio] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Forwarder] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Carrier] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Despachante] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Intl_Ref_Lio] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Cubado_Lio] [decimal](18, 0) NULL,
	[DL_Cargo_Lio] [datetime] NULL,
	[Cd_Vendedor] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Agente] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Status_Lio] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Lio] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Order] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Terminal] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[PO_Req_Date] [datetime] NULL,
	[Cd_Courier] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Courier_Number_Lio] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Canal_Lio] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Original_ETA_LIO] [datetime] NULL,
	[Cd_Transportadora] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[MultiModal] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Invoice] [float] NULL,
	[Cd_Moeda_Invoice] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Banco] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ID_Status] [int] NULL,
 CONSTRAINT [PK_LLP_Imp_Out] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_Lio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
