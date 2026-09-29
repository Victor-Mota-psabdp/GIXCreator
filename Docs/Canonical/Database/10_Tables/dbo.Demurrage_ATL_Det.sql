SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Demurrage_ATL_Det](
	[Processo] [varchar](16) COLLATE Latin1_General_CI_AI NULL,
	[Fatura] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Container] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Tipo_Container] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Devolucao] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[T_Geral] [int] NULL,
	[F_Time] [int] NULL,
	[D_BDP] [int] NULL,
	[D_Cobrados] [int] NULL,
	[T_Diaria] [float] NULL,
	[T_Pagar] [float] NULL,
	[T_diaria2] [float] NULL,
	[D_1periodo] [int] NULL,
	[D_2periodo] [int] NULL,
	[T_diaria3] [float] NULL,
	[D_3periodo] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
