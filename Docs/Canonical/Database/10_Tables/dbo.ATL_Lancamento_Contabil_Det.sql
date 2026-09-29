SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ATL_Lancamento_Contabil_Det](
	[Mov_ID] [int] NOT NULL,
	[lctNumero] [int] NOT NULL,
	[Mes] [int] NOT NULL,
	[Ano] [int] NOT NULL,
	[MovData] [datetime] NOT NULL,
	[Cd_Cta_Ctb] [varchar](13) COLLATE Latin1_General_CI_AI NOT NULL,
	[MovDC] [char](1) COLLATE Latin1_General_CI_AI NOT NULL,
	[MovValor] [float] NOT NULL,
	[Cd_Centro_Custo] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Num_Lcto] [varchar](13) COLLATE Latin1_General_CI_AI NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Historico] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Historico_Complement] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_ATL_Lancamento_Contabil_Det_1] PRIMARY KEY CLUSTERED 
(
	[Mov_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[ATL_Lancamento_Contabil_Det]  WITH CHECK ADD  CONSTRAINT [FK_ATL_Lancamento_Contabil_Det_ATL_Lancamento_Contabil] FOREIGN KEY([lctNumero], [Mes], [Ano])
REFERENCES [dbo].[ATL_Lancamento_Contabil] ([lctNumero], [Mes], [Ano])
GO
ALTER TABLE [dbo].[ATL_Lancamento_Contabil_Det] CHECK CONSTRAINT [FK_ATL_Lancamento_Contabil_Det_ATL_Lancamento_Contabil]
GO
ALTER TABLE [dbo].[ATL_Lancamento_Contabil_Det]  WITH CHECK ADD  CONSTRAINT [FK_ATL_Lancamento_Contabil_Det_Cta_Ctb] FOREIGN KEY([Cd_Cta_Ctb])
REFERENCES [dbo].[Cta_Ctb] ([Cd_Cta_Ctb])
GO
ALTER TABLE [dbo].[ATL_Lancamento_Contabil_Det] CHECK CONSTRAINT [FK_ATL_Lancamento_Contabil_Det_Cta_Ctb]
GO
