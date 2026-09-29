SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Confer_JOB](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Vr_Cambio] [bit] NULL,
	[Proft] [bit] NULL,
	[Justificativa] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Status] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NOT NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[cd_usuario_csr] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[dt_aproval_csr] [datetime] NULL,
	[cd_usuario_chb] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[dt_aproval_chb] [datetime] NULL,
	[cd_usuario_transp] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[dt_aproval_transp] [datetime] NULL,
	[Justificativa_csr] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[Justificativa_chb] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[Justificativa_transp] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[SaldoRepasse] [float] NULL,
	[SaldoResultado] [float] NULL,
	[Prestacao] [bit] NULL,
	[cd_usuario_transp2] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[dt_aproval_transp2] [datetime] NULL,
	[Justificativa_transp2] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Confer_JOB] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
