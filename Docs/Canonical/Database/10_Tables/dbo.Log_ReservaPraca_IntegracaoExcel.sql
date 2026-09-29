SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Log_ReservaPraca_IntegracaoExcel](
	[Num_Proc_Lem] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[DL_Draft_Lem] [datetime] NULL,
	[DL_Cargo_Lem] [datetime] NULL,
	[DL_VGM_Lem] [datetime] NULL,
	[Cd_Usuario] [varchar](6) COLLATE Latin1_General_CI_AI NOT NULL,
	[Dt_Ins] [datetime] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
