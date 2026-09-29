SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IBGE_Municipios_BR](
	[UF] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[UF_Descr_Red] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Nome_UF] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Mesorregiao_Geografica] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Mesorregiao] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Microrregiao_Geografica] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Microrregiao] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cod_IBGE] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Município] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cod_Distrito] [varchar](2) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Distrito] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Subdistrito] [varchar](40) COLLATE Latin1_General_CI_AI NULL,
	[Nome_Subdistrito] [varchar](40) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
