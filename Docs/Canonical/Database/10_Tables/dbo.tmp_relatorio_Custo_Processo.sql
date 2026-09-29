SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_relatorio_Custo_Processo](
	[num_proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_tp_oper] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Consig] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Org] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Dst] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[CarrierName] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Vessel] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[HAWB] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[ETD] [datetime] NULL,
	[ATD] [datetime] NULL,
	[ETA] [datetime] NULL,
	[ATA] [datetime] NULL,
	[dt_desembaraco] [datetime] NULL,
	[Canal] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Qtd_Vol] [decimal](9, 2) NULL,
	[Peso_Liquido] [float] NULL,
	[Peso_Bruto] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
