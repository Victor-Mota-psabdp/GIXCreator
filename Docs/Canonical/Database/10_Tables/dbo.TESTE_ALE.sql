SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TESTE_ALE](
	[Codigo] [varchar](7) COLLATE Latin1_General_CI_AI NOT NULL,
	[Fatura] [varchar](9) COLLATE Latin1_General_CI_AI NULL,
	[CNPJ] [varchar](15) COLLATE Latin1_General_CI_AI NOT NULL,
	[Num_Pedido] [varchar](400) COLLATE Latin1_General_CI_AI NULL,
	[processo] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[Especialista] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Fatura] [datetime] NULL,
	[Pedido] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[cd_pedido] [int] NOT NULL,
	[cd_prod] [int] NOT NULL,
	[Nota_Fiscal] [varchar](20) COLLATE Latin1_General_CI_AI NULL,
	[fob] [float] NULL,
	[num_po] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[GMID] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Emissao] [datetime] NULL,
	[processo_pc] [varchar](16) COLLATE Latin1_General_CI_AI NOT NULL,
	[peso_bruto] [float] NULL,
	[NF] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Business] [varchar](40) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
