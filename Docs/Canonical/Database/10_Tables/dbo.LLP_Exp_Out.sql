SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LLP_Exp_Out](
	[Num_Proc_Leo] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ETA_Leo] [datetime] NULL,
	[ETD_Leo] [datetime] NULL,
	[ATD_Leo] [datetime] NULL,
	[ATA_Leo] [datetime] NULL,
	[Cd_Planta_Leo] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_DstFinal_Leo] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[DL_Cargo_Leo] [datetime] NULL,
	[Cd_Carrier] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Forwarder] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Despachante] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Intl_Ref_Leo] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Cubado_Leo] [decimal](18, 0) NULL,
	[Cd_Vendedor] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Agente] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Status_Leo] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Leo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Order] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Terminal] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Nr_Reserva] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[PO_Req_Date] [datetime] NULL,
	[Cd_Courier] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Courier_Number_Leo] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Canal_Leo] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Original_ETA_Leo] [datetime] NULL,
	[Cd_Transportadora] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Notify_2] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[MultiModal] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Invoice] [float] NULL,
	[Cd_Moeda_Invoice] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Comissao_Agente_Leo] [float] NULL,
	[Banco] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ID_Status] [int] NULL,
 CONSTRAINT [PK_LLP_Exp_Out] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_Leo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
