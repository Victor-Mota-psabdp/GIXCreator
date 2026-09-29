SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Rel_SCHCASS_JOB_AUX](
	[num_proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[FATCOD] [varchar](17) COLLATE Latin1_General_CI_AI NOT NULL,
	[SHIPPER_ID] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[SHIPPER_ACCOUNT] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[MODE] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[MOVEMENT] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[SHIPPER_SID_1] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[SHIPPER_SID_3] [varchar](22) COLLATE Latin1_General_CI_AI NULL,
	[CARRIER_PRO_1] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[CARRIER_PRO_2] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[SHIPPER_NAME] [varchar](8000) COLLATE Latin1_General_CI_AI NULL,
	[SHIPPER_ZIP] [char](8) COLLATE Latin1_General_CI_AI NULL,
	[SHIPPER_CITY] [varchar](8000) COLLATE Latin1_General_CI_AI NULL,
	[SHIPPER_STATE] [char](2) COLLATE Latin1_General_CI_AI NULL,
	[SHIPPER_STREET] [varchar](8000) COLLATE Latin1_General_CI_AI NULL,
	[SHIPPER_CTRY] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[CONSIGNEE_NAME] [varchar](8000) COLLATE Latin1_General_CI_AI NULL,
	[CONSIGNEE_ZIP] [char](8) COLLATE Latin1_General_CI_AI NULL,
	[CONSIGNEE_CITY] [varchar](8000) COLLATE Latin1_General_CI_AI NULL,
	[CONSIGNEE_STATE] [char](2) COLLATE Latin1_General_CI_AI NULL,
	[CONSIGNEE_STREET] [varchar](8000) COLLATE Latin1_General_CI_AI NULL,
	[CONSIGNEE_CTRY] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[INCO_TERMS] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[SHIP_DATE] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[DEPART_DATE] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[ARRIVAL_DATE] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[DELIVERY_DATE] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[SERVICE] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[SERVICE_DESC] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[SHIPPING_LINE] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[GROSS_WEIGHT] [float] NULL,
	[VOLUME] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[CHARGE_WEIGHT] [varchar](17) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
