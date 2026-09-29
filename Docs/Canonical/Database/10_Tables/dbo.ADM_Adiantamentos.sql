SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ADM_Adiantamentos](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Taxa] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Cd_tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NOT NULL,
	[Valor] [decimal](18, 2) NULL,
	[Dt_Adto] [datetime] NULL,
	[Fatura] [varchar](17) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Devol] [datetime] NULL,
	[Encerrado] [bit] NULL,
	[Obs_Adto] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Saldo] [decimal](10, 2) NULL,
	[Valor_Em_Aberto] [decimal](18, 2) NULL,
 CONSTRAINT [PK_ADM_Adiantamentos] PRIMARY KEY CLUSTERED 
(
	[Num_Proc] ASC,
	[Cd_tp_Tx] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
