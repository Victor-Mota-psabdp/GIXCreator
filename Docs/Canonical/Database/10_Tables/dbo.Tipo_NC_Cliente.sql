SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tipo_NC_Cliente](
	[Cd_Pes_Grupo] [varchar](50) COLLATE Latin1_General_CI_AI NOT NULL,
	[Cd_NC] [varchar](40) COLLATE Latin1_General_CI_AI NOT NULL,
	[Parte_Resp] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Processo] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Descricao_nC] [varchar](150) COLLATE Latin1_General_CI_AI NULL,
	[Descricao_NC_ENG] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Descricao_NC_PTG] [varchar](1000) COLLATE Latin1_General_CI_AI NULL,
	[Ativo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[Historico_Padrao] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Ativo_Historico] [bit] NULL,
 CONSTRAINT [PK_Tipo_NC_Cliente] PRIMARY KEY CLUSTERED 
(
	[Cd_Pes_Grupo] ASC,
	[Cd_NC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
