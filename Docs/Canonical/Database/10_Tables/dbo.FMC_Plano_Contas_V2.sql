SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FMC_Plano_Contas_V2](
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Conta_Debito] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Conta_Credito] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Tipo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[ID_Evento] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[PRC_INSS] [float] NULL,
	[Descricao] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Cd_tp_tx_Var] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Montante] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[BDP_Pgto] [char](1) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_FMC_Plano_Contas_V2] PRIMARY KEY CLUSTERED 
(
	[Cd_Tp_Tx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
