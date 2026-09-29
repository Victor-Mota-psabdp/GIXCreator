SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Produto_CHB_16112018](
	[cd_prod] [int] NOT NULL,
	[Etiqueta_Produto] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Aprovado] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Descricao_Longa] [varchar](max) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Pesquisa] [datetime] NULL,
	[Tipo_LI] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Import_License] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Orgao_Anuente] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Pais_Origem] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Concentracao] [float] NULL,
 CONSTRAINT [PK_Produto_CHB_16112018] PRIMARY KEY CLUSTERED 
(
	[cd_prod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
