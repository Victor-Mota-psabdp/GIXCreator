SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Booking_Request](
	[ID_Log] [bigint] IDENTITY(1,1) NOT NULL,
	[Dt_Alter] [datetime] NOT NULL,
	[Tp_Oper] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Armador] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Name_Armador] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Contract_Number] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Local] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Shipper] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Name_Shipper] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Forwarder] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Name_Forwarder] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consignee] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Name_Consignee] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Shipper_Reference_Number] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Forwarder_Reference_Number] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Purchase_Order_Number] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Consignee_Reference_Number] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Move] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Tp_Move] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Carrier_Receipt] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Carrier_Receipt] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Earliest_Departure] [datetime] NULL,
	[Cd_Carrier_Delivery] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Carrier_Delivery] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Latest_Delivery] [datetime] NULL,
	[Cd_Org] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Org] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ETD] [datetime] NULL,
	[Cd_Dst] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Dst] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ETA] [datetime] NULL,
	[Navio] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Navio] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Viagem] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Viagem] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Id_Viagem] [int] NULL,
	[Dt_Ins] [datetime] NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes_grupo] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Notes] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Nr_Reserva] [varchar](250) COLLATE Latin1_General_CI_AI NULL,
	[DL_Cargo_Lem] [datetime] NULL,
	[DL_Draft_Lem] [datetime] NULL,
	[DL_VGM_Lem] [datetime] NULL,
	[INTTRA_Ref] [varchar](250) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Carga] [int] NULL,
	[Cd_Tp_Frete] [varchar](1) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
