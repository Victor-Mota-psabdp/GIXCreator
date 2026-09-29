SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Saldo_Contabil_Processo](
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Entradas_Caixa] [decimal](18, 2) NULL,
	[Saida_Caixa] [decimal](18, 2) NULL,
	[Total_Servicos] [decimal](18, 2) NULL,
	[Total_Custos] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
