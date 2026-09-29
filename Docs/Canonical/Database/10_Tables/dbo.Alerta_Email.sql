SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Alerta_Email](
	[Id] [int] NOT NULL,
	[Grupo] [varchar](30) COLLATE Latin1_General_CI_AI NOT NULL,
	[Nome_Alerta] [varchar](100) COLLATE Latin1_General_CI_AI NOT NULL,
	[Assunto] [varchar](100) COLLATE Latin1_General_CI_AI NULL,
	[Destinatarios] [varchar](2000) COLLATE Latin1_General_CI_AI NULL,
	[Destin_CC] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Destin_CCO] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Desativados] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
	[Comando] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Comando_Teste] [varchar](50) COLLATE Latin1_General_CI_AI NULL,
	[Horario] [int] NULL,
	[Aplicativo] [varchar](3) COLLATE Latin1_General_CI_AI NULL,
	[Dt_Envio] [datetime] NULL,
	[ResponderPara] [varchar](500) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Alerta_Email] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
