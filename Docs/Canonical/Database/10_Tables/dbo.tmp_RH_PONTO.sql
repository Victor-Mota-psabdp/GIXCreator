SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmp_RH_PONTO](
	[Nome_Funcionario] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Pis] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Centro_Custo] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Chefia] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Responsavel] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[t_id] [bigint] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
