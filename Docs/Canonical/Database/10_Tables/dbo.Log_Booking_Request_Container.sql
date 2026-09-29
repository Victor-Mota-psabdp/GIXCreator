SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Booking_Request_Container](
	[ID_Log] [bigint] IDENTITY(1,1) NOT NULL,
	[Dt_Alter] [datetime] NOT NULL,
	[Tp_Oper] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Item_Cont] [int] NOT NULL,
	[Qty] [int] NULL,
	[Cd_Tp_Cont] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Name_Tp_Cont] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Container_Comments] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes_Haulage] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Name_Pes_Haulage] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Requested_Empty_PickUp] [datetime] NULL,
	[Contact_Name] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Contact_Number] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Temperature] [float] NULL,
	[Degree] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Humidity] [float] NULL,
	[Vent_Status] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Length] [decimal](9, 3) NULL,
	[Width] [decimal](9, 3) NULL,
	[Height] [decimal](9, 3) NULL,
	[UoM] [varchar](10) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
