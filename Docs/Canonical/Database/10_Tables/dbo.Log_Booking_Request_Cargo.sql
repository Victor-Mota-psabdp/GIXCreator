SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Booking_Request_Cargo](
	[ID_Log] [bigint] IDENTITY(1,1) NOT NULL,
	[Dt_Alter] [datetime] NOT NULL,
	[Tp_Oper] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Prod] [int] NULL,
	[Cd_Proc_Cliente] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Produto_Description] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[NCM] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Net_Weight] [float] NULL,
	[Gross_Weight] [float] NULL,
	[Qtde_Embal] [int] NULL,
	[Cd_Tp_Embal] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Name_Tp_Embal] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[UN_Number] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[IMO_Class] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Proper_Shipping_Name] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[fsPoint] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Temperature] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Packing_Group] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Emergency_Contact_Name] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Emergency_Contact_Number] [varchar](200) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
