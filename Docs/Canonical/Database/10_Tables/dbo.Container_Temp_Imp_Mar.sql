SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Container_Temp_Imp_Mar](
	[ID] [bigint] NULL,
	[ID_House_Temp] [bigint] NULL,
	[ID_Req] [bigint] NULL,
	[Intl_Reference] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Item_Cont_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Cont] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Name_Type_Container] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_Cont_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Num_Lacre_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Vcto_Devol_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Devol_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Lacre_02_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Lacre_03_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Lacre_04_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Peso_Bruto_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[VolumeM3] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[ID_ISO] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Tara_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[DataDevCli_IM] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[inspecao] [varchar](200) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [varchar](200) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
