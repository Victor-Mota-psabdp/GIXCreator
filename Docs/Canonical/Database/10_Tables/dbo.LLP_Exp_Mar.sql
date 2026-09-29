SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LLP_Exp_Mar](
	[Num_Proc_Lem] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ETA_Lem] [datetime] NULL,
	[ETD_Lem] [datetime] NULL,
	[ATA_Lem] [datetime] NULL,
	[ATD_Lem] [datetime] NULL,
	[Cd_Armador_Lem] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Carga] [int] NULL,
	[Cd_Planta_Lem] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_DstFinal_Lem] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[DL_Draft_Lem] [datetime] NULL,
	[DL_Cargo_Lem] [datetime] NULL,
	[Cd_Courier] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Courier_Number_Lem] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Forwarder] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Intl_Ref_Lem] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Impres_Lem] [datetime] NULL,
	[Status_Lem] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Net_Rates_Lem] [float] NULL,
	[Selling_Rates_Lem] [float] NULL,
	[Canal_Lem] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Order] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Terminal] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[PO_Req_Date] [datetime] NULL,
	[Original_ETA_Lem] [datetime] NULL,
	[Cd_Transportadora] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Notify_2] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Dt_BL_Lem] [datetime] NULL,
	[MultiModal] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Invoice] [float] NULL,
	[Cd_Moeda_Invoice] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Comissao_Agente_Lem] [float] NULL,
	[Banco] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ID_Status] [int] NULL,
	[DL_VGM_Lem] [datetime] NULL,
	[ID_Viagem] [int] NULL,
 CONSTRAINT [PK_LLP_Exp_Mar] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_Lem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
