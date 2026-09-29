SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TransPrice_RH_2010](
	[Job] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Planta] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[GMID] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Produto_Descr] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Cia] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Vendor] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Seller] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[ATD] [datetime] NULL,
	[Desemb] [datetime] NULL,
	[Modal] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Navio] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Origem] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[cd_tp_carga] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Hist] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[ALIQ_II] [float] NULL,
	[ALIQ_IPI] [float] NULL,
	[ALIQ_ICMS] [float] NULL,
	[Paridade] [float] NULL,
	[Payment] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Local] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[cd_produto] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Peso_house] [float] NULL,
	[fVLR_II] [float] NULL,
	[fVLR_AFR] [float] NULL,
	[fVLR_THC] [float] NULL,
	[fVLR_TUP] [float] NULL,
	[fVLR_LII] [float] NULL,
	[fVLR_IPI] [float] NULL,
	[fVLR_ICMS] [float] NULL,
	[fVLR_TRA] [float] NULL,
	[fVLR_SIS] [float] NULL,
	[fVLR_DEM] [float] NULL,
	[fVLR_WHS] [float] NULL,
	[fVLR_BRO] [float] NULL,
	[fVLR_PIS] [float] NULL,
	[fVLR_CFN] [float] NULL,
	[DI] [varchar](100) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
