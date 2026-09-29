SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[House_Temp](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ID_Req] [bigint] NULL,
	[Intl_Reference] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Emis] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[HAWB] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[MAWB] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Export] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Export] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consig] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Consig] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Import] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Import] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Cd_planta] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_planta] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Org] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Org] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Dst] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_DstFinal] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_DstFinal] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Armador] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Armador] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Navio] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Navio] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Viagem] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Viagem] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Id_Viagem] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ETA] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ETD] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ATA] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ATD] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Carga] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Tp_Carga] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Qtd_Tot_Vol] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Vol_Tot] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Liquido] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Bruto] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Tp_Frete] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Moeda] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Tp_Moeda] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Vlr_Frete_Efet] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Original_ETA] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Obs] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Modal] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Id_TP_House_Temp] [bigint] NULL,
	[cd_tp_modal] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[SystemCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[DT_INS_House_Temp] [datetime] NULL,
	[DestinationCountryCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Oper] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Incoterm] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Cubado] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Booking_Number] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[dt_ins] [datetime] NULL,
	[OriginCountryCode] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_House_Temp] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[House_Temp] ADD  DEFAULT (getdate()) FOR [dt_ins]
GO
