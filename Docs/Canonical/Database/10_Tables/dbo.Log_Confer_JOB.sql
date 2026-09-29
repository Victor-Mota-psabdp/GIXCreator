SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_Confer_JOB](
	[Dt_Alter] [datetime] NULL,
	[Tp_Oper] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Vr_Cambio] [bit] NULL,
	[Proft] [bit] NULL,
	[Justificativa] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Status] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Ins] [datetime] NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[cd_usuario_csr] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[dt_aproval_csr] [datetime] NULL,
	[cd_usuario_chb] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[dt_aproval_chb] [datetime] NULL,
	[cd_usuario_transp] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[dt_aproval_transp] [datetime] NULL,
	[Justificativa_csr] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Justificativa_chb] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Justificativa_transp] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[SaldoRepasse] [float] NULL,
	[SaldoResultado] [float] NULL,
	[Prestacao] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
