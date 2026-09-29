SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ATL_Saldo_Cta_Cte](
	[Cd_Banco] [varchar](4) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Agencia] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Num_Cta_Cte] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Mov] [datetime] NULL,
	[Saldo] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
