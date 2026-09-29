SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Rel_221_JOBS](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[ID_status] [int] NULL,
	[Cd_Org] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[cd_armador] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[HAWB] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[MAWB] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Master] [varchar](14) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Emis] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[PO_Req_Date] [datetime] NULL,
	[Modal] [varchar](12) COLLATE Latin1_General_CI_AI NOT NULL,
	[Peso_Bruto] [float] NULL,
	[Vessel] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ETD] [datetime] NULL,
	[ATD] [datetime] NULL,
	[Original_ETA] [datetime] NULL,
	[ETA] [datetime] NULL,
	[ATA] [datetime] NULL,
	[Dead_line] [datetime] NULL,
	[Cut_Date] [datetime] NULL,
	[Banco] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Canal] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Booking_Number] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_invoice] [float] NULL,
	[Peso_Liquido] [float] NULL,
	[Apelido_Shipper] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Apelido_Consignee] [varchar](20) COLLATE Latin1_General_CI_AI NOT NULL,
	[Apelido_PG] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Tp_Carga] [varchar](30) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
