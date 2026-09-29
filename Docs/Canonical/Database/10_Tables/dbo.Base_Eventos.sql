SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Base_Eventos](
	[Razao_Empresa] [varchar](60) COLLATE Latin1_General_CI_AI NOT NULL,
	[CNPJ] [varchar](14) COLLATE Latin1_General_CI_AI NOT NULL,
	[Seq_Eventos] [int] NOT NULL,
	[Cod_Empresa_SVIA] [char](3) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
