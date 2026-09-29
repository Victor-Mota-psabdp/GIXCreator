SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LLP_Exp_Aer](
	[Num_Proc_Lea] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ETA_Lea] [datetime] NULL,
	[ETD_Lea] [datetime] NULL,
	[ATA_Lea] [datetime] NULL,
	[ATD_Lea] [datetime] NULL,
	[Cd_CiaAerea_Lea] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Planta_Lea] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_DstFinal_Lea] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[DL_Cargo_Lea] [datetime] NULL,
	[Cd_Courier] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Courier_Number_Lea] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Forwarder] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Intl_Ref_Lea] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Impres_Lea] [datetime] NULL,
	[Status_Lea] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Net_Rates_Lea] [float] NULL,
	[Selling_Rates_Lea] [float] NULL,
	[Peso_Cubado_Lea] [decimal](9, 3) NULL,
	[Cd_Order] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Terminal] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[PO_Req_Date] [datetime] NULL,
	[Canal_Lea] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Original_ETA_Lea] [datetime] NULL,
	[Cd_Transportadora] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Notify_2] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[MultiModal] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Invoice] [float] NULL,
	[Cd_Moeda_Invoice] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Comissao_Agente_Lea] [float] NULL,
	[Banco] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ID_Status] [int] NULL,
	[dt_ImpressDraft_lea] [datetime] NULL,
	[cd_User_Impres_Lea] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_LLP_Exp_Aer] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_Lea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
