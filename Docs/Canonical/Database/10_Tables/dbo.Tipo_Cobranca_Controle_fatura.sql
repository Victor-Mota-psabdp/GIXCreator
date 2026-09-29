SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_Cobranca_Controle_fatura](
	[id_dc] [int] NOT NULL,
	[nome_doc] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[cd_doc] [varchar](3) COLLATE Latin1_General_CI_AI NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
