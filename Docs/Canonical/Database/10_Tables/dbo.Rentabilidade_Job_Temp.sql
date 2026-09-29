SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Rentabilidade_Job_Temp](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[GrossRevenue] [float] NULL,
	[Costs] [float] NULL,
	[NF] [float] NULL,
	[CHB_Credito] [float] NULL,
	[CHB_Debito] [float] NULL,
	[CHB_Saldo] [float] NULL,
	[Custo_Master] [float] NULL,
	[Net_Revenue] [float] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
