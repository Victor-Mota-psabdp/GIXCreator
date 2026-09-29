SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[House_Exp_Out](
	[Num_Proc_HEO] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Emis_HEO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Tp_Etapa] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[HAWB_HEO] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[MAWB_HEO] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consig_HEO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Export_HEO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Notify_HEO] [varchar](10) COLLATE Latin1_General_CI_AI NOT NULL,
	[Voo_HEO] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Org_HEO] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_Dst_HEO] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Qtd_Tot_Vol_HEO] [decimal](9, 2) NULL,
	[Peso_Real_HEO] [float] NULL,
	[Peso_Bruto_HEO] [float] NULL,
	[Vol_Tot_HEO] [decimal](7, 3) NULL,
	[Tp_Frete_HEO] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete_Efet_HEO] [decimal](10, 2) NULL,
	[Cd_Tp_Oper] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Obs_HEO] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Sap_ShipNumber] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[TTime_d] [smallint] NULL,
 CONSTRAINT [PK_House_Exp_Out] PRIMARY KEY CLUSTERED 
(
	[Num_Proc_HEO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
