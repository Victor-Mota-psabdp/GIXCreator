SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_Rel_221_JOB_AUX](
	[NUM_PROC] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Tp_Carga] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Local_Origem] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Local_Destino] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Pais_Local] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Regiao] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Armador] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Descr] [varchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Orgao_Anuente] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[status_descricao] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Containers] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Container Type] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Pgto_Rcto_HIA] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[BDP Invoice Date] [datetime] NULL,
	[Cd_BDP Last Historic] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Last Historic] [varchar](700) COLLATE Latin1_General_CI_AI NULL,
	[Last Update] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
