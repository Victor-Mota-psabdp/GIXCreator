SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LLP_Imp_Aer](
	[Num_Proc_Lia] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ETA_LIA] [datetime] NULL,
	[ETD_LIA] [datetime] NULL,
	[ATA_LIA] [datetime] NULL,
	[ATD_LIA] [datetime] NULL,
	[Cd_Planta_LIA] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_DstFinal_LIA] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Forwarder] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Status_LIA] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Cubado_LIA] [decimal](9, 3) NULL,
	[Cd_Order] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Terminal] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Intl_Ref_LIA] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[PO_Req_Date] [datetime] NULL,
	[Canal_LIA] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Courier] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Courier_Number_Lia] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[DL_Cargo_Lia] [datetime] NULL,
	[Original_ETA_LIA] [datetime] NULL,
	[Cd_Transportadora] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[MultiModal] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Invoice] [float] NULL,
	[Cd_Moeda_Invoice] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Banco] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ID_Status] [int] NULL,
	[dt_impres_lia] [datetime] NULL,
 CONSTRAINT [PK_LLP_Imp_Aer] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_Lia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
