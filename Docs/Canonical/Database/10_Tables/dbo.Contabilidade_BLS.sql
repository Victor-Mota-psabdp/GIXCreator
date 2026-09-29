SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Contabilidade_BLS](
	[Data] [datetime] NULL,
	[Num_Proc] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Tp_Tx] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[DC] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Valor] [decimal](10, 2) NULL,
	[Valor_RS] [decimal](10, 2) NULL,
	[Tipo] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Encerrado] [bit] NULL,
	[Conta_Debito] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Conta_Credito] [varchar](15) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Pes] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Historico] [varchar](300) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
