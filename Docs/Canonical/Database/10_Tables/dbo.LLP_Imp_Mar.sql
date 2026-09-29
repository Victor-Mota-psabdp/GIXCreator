SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LLP_Imp_Mar](
	[Num_Proc_Lim] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ETA_Lim] [datetime] NULL,
	[ETD_Lim] [datetime] NULL,
	[ATA_Lim] [datetime] NULL,
	[ATD_lim] [datetime] NULL,
	[Cd_Tp_Carga] [int] NULL,
	[Cd_planta_Lim] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_DstFinal_Lim] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Forwarder] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Status_LIM] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Canal_Lim] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Order] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Terminal] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Nr_Reserva] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Intl_Ref_Lim] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[PO_Req_Date] [datetime] NULL,
	[DL_Cargo_Lim] [datetime] NULL,
	[Cd_Courier] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Courier_Number_Lim] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Original_ETA_LIM] [datetime] NULL,
	[Cd_Transportadora] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[ID_Viagem] [int] NULL,
	[ID_Viagem_Transb] [int] NULL,
	[MultiModal] [varchar](8) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Invoice] [float] NULL,
	[Cd_Moeda_Invoice] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Banco] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Impres_LIM] [datetime] NULL,
	[ID_Status] [int] NULL,
 CONSTRAINT [PK_LLP_Imp_Mar] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_Lim] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
