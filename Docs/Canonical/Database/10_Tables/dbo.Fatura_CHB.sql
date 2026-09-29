SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Fatura_CHB](
	[Fatura_PC] [char](17) COLLATE Latin1_General_CI_AI NOT NULL,
	[Processo_PC] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[DI_RE_PC] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[Data_PC] [datetime] NULL,
	[cd_pes_PC] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Status_PC] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Obs_PC] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tipo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Usuario_Print] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Print] [datetime] NULL,
	[Cd_Tipo_Print] [varchar](1) COLLATE Latin1_General_CI_AI NULL,
	[BDP_Invoice] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Fatura_CHB] PRIMARY KEY CLUSTERED 
(
	[Fatura_PC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
