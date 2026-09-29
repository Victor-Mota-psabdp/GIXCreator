SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Booking_Request_Container](
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
	[UoM] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Booking_Request_Container] PRIMARY KEY CLUSTERED 
(
	[Num_Proc] ASC,
	[Item_Cont] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
