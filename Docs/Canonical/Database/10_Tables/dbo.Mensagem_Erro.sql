SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Mensagem_Erro](
	[Cod_Erro] [int] NOT NULL,
	[Local] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Modais] [varchar](30) COLLATE Latin1_General_CI_AI NULL,
	[Descricao] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Msg_Portugues] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Msg_Ingles] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Msg_Espanhol] [varchar](300) COLLATE Latin1_General_CI_AI NULL,
	[Ativo] [char](1) COLLATE Latin1_General_CI_AI NULL,
	[dt_criacao] [datetime] NULL,
 CONSTRAINT [PK_Mensagem_Erro] PRIMARY KEY CLUSTERED 
(
	[Cod_Erro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Mensagem_Erro] ADD  DEFAULT (getdate()) FOR [dt_criacao]
GO
