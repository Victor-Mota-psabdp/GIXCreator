SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SCAC_Localidade](
	[UN_LOCTN_CHNG_CD] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[ISO_2_LTR_CNTRY_CD] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_CD] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_NM] [varchar](255) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_WO_DIACRITICS_NM] [varchar](255) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_SUBDIV_CD] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_STATUS_CD] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_FNCTN_POS_1_CD] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_FNCTN_POS_2_CD] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_FNCTN_POS_3_CD] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_FNCTN_POS_4_CD] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_FNCTN_POS_5_CD] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_FNCTN_POS_6_CD] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_FNCTN_POS_7_CD] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_FNCTN_POS_8_CD] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_LAST_MODFD_DT] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_IATA_CD] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_LONGITUDE_CD] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[UN_LOCTN_LATITUDE_CD] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[IATA_3_LTR_CITY_CD] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[IATA_3_LTR_AIRPORT_CD] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[SCHED_D_K_CD] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[CREATED_BY] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[CREATED_ON] [datetime] NULL,
	[LAST_MODFD_BY] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[LAST_MODFD_DT] [datetime] NULL,
	[dt_ins] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SCAC_Localidade] ADD  DEFAULT (getdate()) FOR [dt_ins]
GO
