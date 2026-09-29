SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Tipo_Status_BO](
	[ID_Status] [int] NOT NULL,
	[Status_Descricao] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Ativo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[CtaCte_IUD] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Financeiro_IUD] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Faturamento_IUD] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Job_IUD] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Historico_IUD] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Status_Descricao_Ingles] [varchar](60) COLLATE Latin1_General_CI_AI NULL,
	[Ordem] [int] NULL,
 CONSTRAINT [PK_Tipo_Status_BO] PRIMARY KEY CLUSTERED 
(
	[ID_Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
