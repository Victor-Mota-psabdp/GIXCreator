SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Err_Eventos](
	[Arquivo_Err] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Cd_Err] [varchar](6) COLLATE Latin1_General_CI_AI NULL,
	[Campo_Err] [varchar](25) COLLATE Latin1_General_CI_AI NULL,
	[Chave_Err] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Viagem_Err] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[BL_Err] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Porto_Err] [varchar](5) COLLATE Latin1_General_CI_AI NULL,
	[Armador_Err] [char](4) COLLATE Latin1_General_CI_AI NULL,
	[Emissao_Err] [datetime] NULL,
	[Viagem_Age_Err] [varchar](10) COLLATE Latin1_General_CI_AI NULL,
	[Mensagem_Err] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Linha_Err] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
