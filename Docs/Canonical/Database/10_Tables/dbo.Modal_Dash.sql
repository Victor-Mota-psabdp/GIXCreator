SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Modal_Dash](
	[Modal] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Data Presença Carga] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Data Liberação BL] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[ATA] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Data Pgto. AFRMM] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Data D.I.] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Data Desembaraço] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Data Canal] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Data Env. Draft NFe] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Data Entr. Docs Transp.] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Tipo] [varchar](50) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
